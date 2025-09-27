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
    var value: String
    let childrenCount: Int
    let serialNumber: Int

    var id: TreeNode.ID {
        ID(rawValue: serialNumber)
    }

    var isParent: Bool {
        childrenCount > 0
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
        childrenCount: Int
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.serialNumber = serialNumber
        self.childrenCount = childrenCount

        do {
            try TreeNodeRegistry.shared.registerNode(serialNumber: serialNumber, value: value)
        } catch {
            if value != oldValue {
                TreeNodeRegistry.shared.registerChangedNode(self)
            }
        }
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: "Root node",
        label: "Root node",
        value: "Root node",
        serialNumber: -1,
        childrenCount: 0 //is actually 2 (modifiedView+originalView) but collapsing the root node does not make sense
    )
}
