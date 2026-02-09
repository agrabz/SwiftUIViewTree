import Foundation
import SwiftUI

struct DraftTreeNode: Sendable {
    let type: String
    let label: String
    let value: String

    init(
        type: String,
        label: String,
        value: String,
    ) {
        self.type = type
        self.label = label
        self.value = value
    }
}

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
    private var oldNode: TreeNode? {
        TreeNodeRegistry.shared.getRegisteredNodeWith(serialNumber: serialNumber)
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
            try TreeNodeRegistry.shared.registerNode(serialNumber: serialNumber, node: self)
        } catch {
            if value != oldNode?.value {
                /// Breaking change!
                if type != oldNode?.type {
                    print("oldType: \(String(describing: oldNode?.type)), newType: \(type)")
                    return
                }
                /// Breaking change!
                if label != oldNode?.label {
                    print("oldLabel: \(String(describing: oldNode?.label)), newLabel: \(label)")
                    return //TODO: trigger tree redraw
                }
                if !Configuration.shared.isMemoryAddressDiffingEnabled && MemoryAddress.hasDiffInMemoryAddress(lhs: value, rhs: oldNode?.value ?? "") {
                    return
                }

                ViewTreeLogger.shared.logChangesOf(
                    node: self,
                    previousNodeValue: oldNode?.value ?? ""
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

extension TreeNode: @MainActor Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
        hasher.combine(self.value)
        hasher.combine(self.type)
        hasher.combine(self.serialNumber)
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
