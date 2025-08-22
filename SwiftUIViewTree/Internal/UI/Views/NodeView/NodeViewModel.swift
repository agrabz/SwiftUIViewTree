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

    func getBackgroundColorAndLogChanges(for node: TreeNode) -> Color {
        if previousNodeValue == nil {
            previousNodeValue = node.value
        } else if let previousNodeValue, previousNodeValue != node.value {
            print()
            print("🚨Changes detected")
            print("\"\(node.label)\":", "\"\(node.type)\"")
            print("🟥Old value:", "\"\(previousNodeValue)\"")
            print("🟩New value:", "\"\(node.value)\"") //TODO: values are sometimes very long. some better highlighting will be needed.
            print()
            self.previousNodeValue = node.value
        } else {
            print("Shouldn't be here, please report it as a bug here: https://github.com/agrabz/SwiftUIViewTree/issues") //TODO: there are already some logs like this...:)
        }

        let backgroundColor = colors.safeGetElement(at: currentIndex % colors.count) ?? colors[0]
        currentIndex += 1
        return backgroundColor
    }
}

