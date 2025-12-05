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
            if value != oldValue { //TODO: except memory addresses
                if hasDiffInMemoryAddress(value, oldValue) {
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

    func hasDiffInMemoryAddress(_ s: String, _ f: String) -> Bool {
        guard s != f else { return false }

        let arr1 = Array(s)
        let arr2 = Array(f)
        let maxLen = max(arr1.count, arr2.count)

        for i in 0..<maxLen {
            let char1 = i < arr1.count ? arr1[i] : nil
            let char2 = i < arr2.count ? arr2[i] : nil

            if char1 != char2 {
                // Found a difference, check if we're inside a memory address
                if isInsideMemoryAddress(s, at: i) || isInsideMemoryAddress(f, at: i) {
                    return true
                }
            }
        }

        return false
    }

    func isInsideMemoryAddress(_ str: String, at index: Int) -> Bool {
        let arr = Array(str)
        guard index < arr.count else { return false }

        // Look backwards for "0x"
        var start = -1
        for i in stride(from: index, through: 0, by: -1) {
            if i > 0 && arr[i-1] == "0" && arr[i] == "x" {
                start = i - 1
                break
            }
            // If we hit a terminator before finding 0x, we're not in a memory address
            if arr[i] == " " || arr[i] == ">" {
                return false
            }
        }

        guard start >= 0 else { return false }

        // Look forwards for terminator (space or >)
        for i in (index+1)..<arr.count {
            if arr[i] == " " || arr[i] == ">" {
                return true
            }
            // If we hit something that's not a valid hex char, not a memory address
            if !arr[i].isHexDigit && arr[i] != "x" {
                return false
            }
        }

        // Reached end of string, still could be a memory address
        return true
    }

    /// To be able to set the value from async, non MainActor isolated contexts, we have to have this setter.
    /// "await node.value = await someOtherValue" is not valid
    func setValueWithAnimation(to: String) {
        withAnimation {
            self.value = to
        }
    }
}

extension Character {
    var isHexDigit: Bool {
        return self.isNumber || ("a"..."f").contains(self) || ("A"..."F").contains(self)
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
