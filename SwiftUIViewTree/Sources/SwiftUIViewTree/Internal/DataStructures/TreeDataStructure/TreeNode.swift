import Foundation
import SwiftUI

@MainActor
@Observable
final class TreeNode: @unchecked Sendable, @MainActor Equatable {
    struct ID: Hashable {
        let rawValue: Int
    }

    @ObservationIgnored
    private var availableColors = LinkedColorList()

    let type: String
    let label: String
    var value: String
    let serialNumber: Int
    let childrenCount: Int

    @ObservationIgnored
    private var oldValue: String {
        TreeNodeMemoizer.shared.getRegisteredValueOfNodeWith(serialNumber: serialNumber) ?? ""
    }
    @ObservationIgnored
    private var oldBackgroundColor = UIConstants.Color.initialNodeBackground
    var backgroundColor: Color {
        if label == "_value" {
            print("asdsa")
        }

        if CollapsedNodesStore.shared.isCollapsed(nodeID: id) {
            return UIConstants.Color.collapsedNodeBackground
        }

        guard TreeNodeMemoizer.shared.isNodeChanged(serialNumber: self.serialNumber) else {
            return oldBackgroundColor
        }

        oldBackgroundColor = availableColors.getNextColor()
        TreeNodeMemoizer.shared.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: serialNumber)
        return oldBackgroundColor
    }

    var isParent: Bool {
        childrenCount > 0
    }

    var id: TreeNode.ID {
        ID(rawValue: serialNumber)
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

        print(serialNumber)

        if label == "_value" {
            print(label)
        }

        do {
            try TreeNodeMemoizer.shared.registerNode(serialNumber: serialNumber, value: value)
        } catch {
            if value != oldValue {
                TreeNodeMemoizer.shared.registerChangedNode(self)
            }
        }
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.id == rhs.id
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
