
@testable import SwiftUIViewTree

final class SpyViewTreeLogger: ViewTreeLoggerProtocol {
    nonisolated(unsafe) var hasBeenCalled = false

    func logChangesOf(node: SwiftUIViewTree.TreeNode, previousNodeValue: String) {
        hasBeenCalled = true
    }
}
