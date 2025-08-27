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
    private var previousCollapseState: Bool?

    func getBackgroundColorAndLogChanges(node: TreeNode) -> Color {
        defer {
            previousCollapseState = CollapsedNodesStore.shared.isCollapsed(nodeID: node.id)
            previousNodeValue = node.value
        }

        if node.label == "some" && node.type == "StoredLocation<Bool>" {
            print("here")
        }

        if node.label == "isActive" && node.type == "Bool" {
            print("here2")
        }

//        #error("collapsing an unchanged parent will first change color then for 2nd or 3rd click collapse")
        if let previousCollapseState, previousCollapseState != CollapsedNodesStore.shared.isCollapsed(nodeID: node.id) {
            let previousIndex = currentIndex - 1
            return colors.safeGetElement(at: previousIndex % colors.count) ?? colors[0]
        }

        if let previousNodeValue, previousNodeValue != node.value {
            print()
            print("🚨Changes detected")
            print("\"\(node.label)\":", "\"\(node.type)\"")
            print("🟥Old value:", "\"\(previousNodeValue)\"")
            print("🟩New value:", "\"\(node.value)\"") //TODO: values are sometimes very long. some better highlighting will be needed.
            print()
        } else if previousNodeValue == node.value {
            print("Shouldn't be here, please report it as a bug here: https://github.com/agrabz/SwiftUIViewTree/issues") //TODO: there are already some logs like this...:)
        }

        let backgroundColor = colors.safeGetElement(at: currentIndex % colors.count) ?? colors[0]
        currentIndex += 1
        return backgroundColor
    }
}

