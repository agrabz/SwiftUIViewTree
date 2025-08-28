import SwiftUI

final class NodeViewModel {

    let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
    ]

    private var currentIndex = 0

    private var previousNodeValue: String?

    func getBackgroundColorAndLogChanges(node: TreeNode) -> Color {
        defer {
            previousNodeValue = node.value
        }

        if CollapsedNodesStore.shared.isCollapsed(nodeID: node.id) {
            return UIConstants.Color.collapsedNodeBackground
        }

        if let previousNodeValue, previousNodeValue != node.value {
            print()
            print("🚨Changes detected")
            print("\"\(node.label)\":", "\"\(node.type)\"")
            print("🟥Old value:", "\"\(previousNodeValue)\"")
            print("🟩New value:", "\"\(node.value)\"") //TODO: values are sometimes very long. some better highlighting will be needed.
            print()
        } else if previousNodeValue == node.value {
            let previousIndex = currentIndex - 1
            return colors.safeGetElement(at: previousIndex % colors.count) ?? colors[0]
        }

        let backgroundColor = colors.safeGetElement(at: currentIndex % colors.count) ?? colors[0]
        currentIndex += 1
        return backgroundColor
    }
}

