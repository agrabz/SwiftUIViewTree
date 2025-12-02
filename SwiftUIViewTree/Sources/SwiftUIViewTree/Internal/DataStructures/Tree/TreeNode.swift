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
        if self.type.count > 20 {
            String(self.type.prefix(20)) + "..."
        } else {
            self.type
        }
    }

    @ObservationIgnored
    var shortenedLabel: String {
        if self.label.count > 20 {
            String(self.label.prefix(20)) + "..."
        } else {
            self.label
        }
    }

    @ObservationIgnored
    var shortenedValue: String {
        if self.value.count > 20 {
            String(self.value.prefix(20)) + "..."
        } else {
            self.value
        }
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
