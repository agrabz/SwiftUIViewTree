
import Foundation

struct ViewTreeLogger: ViewTreeLoggerProtocol {
    @TaskLocal static var shared: ViewTreeLoggerProtocol = ViewTreeLogger()

    func logChangesOf(node: TreeNode, previousNodeValue: String) {
        print()
        print("🚨Changes detected")
        print("\"\(node.label)\":", "\"\(node.type)\"")
        print("🟥Old value:", "\"\(previousNodeValue)\"")
        print("🟩New value:", "\"\(node.value)\"") //TODO: values are sometimes very long. some better highlighting will be needed.
        print()
    }
}

protocol ViewTreeLoggerProtocol: Sendable {
    func logChangesOf(node: TreeNode, previousNodeValue: String)
}
