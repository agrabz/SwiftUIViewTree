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
                if hasDiffInMemoryAddress(lhs: value, rhs: oldValue) {
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
    enum MemoryChars {
        enum TerminatorChars: Character, CaseIterable {
            case space = " "
            case x = ">"
        }

        static let firstOpeningChar: Character = "0"
        static let secondOpeningChar: Character = "x"
    }

    static let prefixValue = 20

    func shorten(_ string: String) -> String {
        if string.count > Self.prefixValue {
            String(string.prefix(Self.prefixValue)) + "..."
        } else {
            string
        }
    }

    func hasDiffInMemoryAddress(lhs: String, rhs: String) -> Bool {
        guard lhs != rhs else { return false }

        let lhsStringElementArray = Array(lhs)
        let rhsStringElementArray = Array(rhs)
        let maxLength = max(lhsStringElementArray.count, rhsStringElementArray.count)

        for index in 0..<maxLength {
            let lhsChar = index < lhsStringElementArray.count ? lhsStringElementArray.safeGetElement(at: index) : nil
            let rhsChar = index < rhsStringElementArray.count ? rhsStringElementArray.safeGetElement(at: index) : nil

            if lhsChar != rhsChar {
                // Found a difference, check if we're inside a memory address
                if isInsideMemoryAddress(fullString: lhs, at: index) || isInsideMemoryAddress(fullString: rhs, at: index) {
                    return true
                }
            }
        }

        return false
    }

    func isInsideMemoryAddress(fullString: String, at indexToStartCheckingFrom: Int) -> Bool {
        let stringElementArray = Array(fullString)

        guard indexToStartCheckingFrom < stringElementArray.count else { return false }

        let terminatorChars = MemoryChars.TerminatorChars.allCases.map(\.rawValue)

        // Look backwards for "0x"
        var memoryAddressStartIndex = -1
        for index in stride(from: indexToStartCheckingFrom, through: 0, by: -1) {
            if
                index > 0 &&
                    stringElementArray.safeGetElement(at: index-1) == MemoryChars.firstOpeningChar &&
                    stringElementArray.safeGetElement(at: index) == MemoryChars.secondOpeningChar
            {
                memoryAddressStartIndex = index - 1
                break
            }
            // If we hit a terminator before finding 0x, we're not in a memory address
            for terminatorChar in terminatorChars {
                if stringElementArray[index] == terminatorChar {
                    return false
                }
            }
        }

        guard memoryAddressStartIndex >= 0 else { return false }

        // Look forwards for terminator
        for index in (indexToStartCheckingFrom+1)..<stringElementArray.count {
            for terminatorChar in terminatorChars {
                if stringElementArray.safeGetElement(at: index) == terminatorChar {
                    return true
                }
            }

            // If we hit something that's not a valid hex char, not a memory address
            let isHex = stringElementArray.safeGetElement(at: index)?.isHexDigit == true

            if !isHex && stringElementArray.safeGetElement(at: index) != MemoryChars.secondOpeningChar {
                return false
            }
        }

        // Reached end of string, still could be a memory address
        return true
    }
}
