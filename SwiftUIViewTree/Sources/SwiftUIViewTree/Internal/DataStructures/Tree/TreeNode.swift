import Foundation
import SwiftUI

@MainActor
@Observable
final class TreeNode: Sendable {
    struct ID: Hashable {
        let rawValue: Int
    }

    let type: String
    let label: String
    private(set) var value: String
    let serialNumber: Int

    var descendantCount = 0

    var id: TreeNode.ID {
        ID(rawValue: serialNumber)
    }

    var isParent: Bool {
        descendantCount > 0
    }

    @ObservationIgnored
    var shortenedType: String {
        self.shorten(self.type)
    }

    @ObservationIgnored
    var shortenedLabel: String {
        self.shorten(self.label)
    }

    @ObservationIgnored
    var shortenedValue: String {
        self.shorten(self.value)
    }

    @ObservationIgnored
    var isCollapsed: Bool {
        CollapsedNodesStore.shared.isCollapsed(nodeID: self.id)
    }

    @ObservationIgnored
    private var availableColors = LinkedColorList()

    @ObservationIgnored
    private var oldValue: String {
        TreeNodeRegistry.shared.getRegisteredValueOfNodeWith(serialNumber: serialNumber) ?? ""
    }
    @ObservationIgnored
    private var oldBackgroundColor = UIConstants.Color.initialNodeBackground
    var backgroundColor: Color {
        if CollapsedNodesStore.shared.isCollapsed(nodeID: id) {
            return UIConstants.Color.collapsedNodeBackground
        }

        guard TreeNodeRegistry.shared.isNodeChanged(serialNumber: self.serialNumber) else {
            return oldBackgroundColor
        }

        oldBackgroundColor = availableColors.getNextColor()
        TreeNodeRegistry.shared.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: serialNumber)
        return oldBackgroundColor
    }

    init(
        type: String,
        label: String,
        value: String,
        serialNumber: Int,
        registerChanges: Bool
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.serialNumber = serialNumber

//        print(serialNumber, type, label, value, descendantCount)

        guard registerChanges else {
            return
        }

        do {
            try TreeNodeRegistry.shared.registerNode(serialNumber: serialNumber, value: value)
        } catch {
            if value != oldValue {
                /// SwiftUI uses reference types under the hood sometimes for things like `LocalizedTextStorage`.
                /// These may change for less obvious reasons and keeping track of them is most probably not super useful, nor helpful.
                if MemoryAddress.hasDiffInMemoryAddress(lhs: value, rhs: oldValue) {
                    return
                }

                ViewTreeLogger.shared.logChangesOf(
                    node: self,
                    previousNodeValue: oldValue
                )

                TreeNodeRegistry.shared.registerChangedNode(self)
            }
        }
    }

    /// To be able to set the value from async, non MainActor isolated contexts, we have to have this setter.
    /// "await node.value = await someOtherValue" is not valid
    func setValueWithAnimation(to: String) {
        withAnimation {
            self.value = to
        }
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: "Root node",
        label: "Root node",
        value: "Root node",
        serialNumber: -1,
        registerChanges: true
    )
}

extension TreeNode: @MainActor CustomStringConvertible {
    var description: String {
        "(\(self.serialNumber)) \(self.label): \(self.type) = \(self.value)"
    }
}

extension TreeNode: @MainActor Equatable {
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.type == rhs.type &&
        lhs.label == rhs.label
    }
}

private extension TreeNode {
    static let prefixValue = 20

    func shorten(_ string: String) -> String {
        if string.count > Self.prefixValue {
            String(string.prefix(Self.prefixValue)) + "..."
        } else {
            string
        }
    }
}


enum MemoryAddress {
    enum OpeningChars {
        static let first: Character = "0"
        static let second: Character = "x"
    }

    enum TerminatorChars: Character, CaseIterable {
        case space = " "
        case x = ">"
    }

    enum LookUpResult {
        case found(index: Int)
        case invalidMemoryAddress
        case notFound
    }


    static func hasDiffInMemoryAddress(lhs: String, rhs: String) -> Bool {
        guard lhs != rhs else { return false }

        let lhsStringElementArray = Array(lhs)
        let rhsStringElementArray = Array(rhs)
        let maxLength = max(lhsStringElementArray.count, rhsStringElementArray.count)

        for index in 0..<maxLength {
            let lhsChar = index < lhsStringElementArray.count ? lhsStringElementArray.safeGetElement(at: index) : nil
            let rhsChar = index < rhsStringElementArray.count ? rhsStringElementArray.safeGetElement(at: index) : nil

            if lhsChar != rhsChar {
                if isInsideMemoryAddress(fullString: lhs, at: index) || isInsideMemoryAddress(fullString: rhs, at: index) {
                    return true
                }
            }
        }

        return false
    }

    static func isInsideMemoryAddress(fullString: String, at indexToStartCheckingFrom: Int) -> Bool { //TODO: implementation could be simplified by taking into account that a 62bit memory address is always 2+16 character long
        let stringElementArray = Array(fullString)

        guard indexToStartCheckingFrom < stringElementArray.count else { return false }

        let result = lookBackwardForMemoryStartChars(indexToStartCheckingFrom: indexToStartCheckingFrom, stringElementArray: stringElementArray)

        return switch result {
            case .found(let index):
                isValidMemoryAddress(indexToStartCheckingFrom: index, fullStringAsElementArray: stringElementArray)
            case .invalidMemoryAddress, .notFound:
                false
        }
    }

    static func lookBackwardForMemoryStartChars(indexToStartCheckingFrom: Int, stringElementArray: [Character]) -> MemoryAddress.LookUpResult {
        for index in stride(from: indexToStartCheckingFrom, through: 0, by: -1) {
            if indexMatchesMemoryAddressStart(index: index, stringElementArray: stringElementArray) {
                return .found(index: index - 1)
            }

            if isTerminationCharacter(stringElementArray: stringElementArray, index: index) {
                return .invalidMemoryAddress
            }
        }

        return .notFound
    }

    static func indexMatchesMemoryAddressStart(index: Int, stringElementArray: [Character]) -> Bool {
        index > 0 &&
        stringElementArray.safeGetElement(at: index-1) == MemoryAddress.OpeningChars.first &&
        stringElementArray.safeGetElement(at: index) == MemoryAddress.OpeningChars.second
    }

    static func isValidMemoryAddress(indexToStartCheckingFrom: Int, fullStringAsElementArray stringElementArray: [Character]) -> Bool {
        for index in (indexToStartCheckingFrom+1)..<stringElementArray.count {
            if isTerminationCharacter(stringElementArray: stringElementArray, index: index) {
                return true
            }

            if isNotValidMemoryAddressCharacter(stringElementArray: stringElementArray, index: index) {
                return false
            }
        }

        // End of string is also valid termination
        return true
    }

    static func isTerminationCharacter(stringElementArray: [Character], index: Int) -> Bool {
        let terminatorChars = MemoryAddress.TerminatorChars.allCases.map(\.rawValue)

        for terminatorChar in terminatorChars {
            if stringElementArray.safeGetElement(at: index) == terminatorChar {
                return true
            }
        }

        return false
    }

    static func isNotValidMemoryAddressCharacter(stringElementArray: [Character], index: Int) -> Bool {
        let isHex = stringElementArray.safeGetElement(at: index)?.isHexDigit == true

        return !isHex && stringElementArray.safeGetElement(at: index) != MemoryAddress.OpeningChars.second
    }
}
