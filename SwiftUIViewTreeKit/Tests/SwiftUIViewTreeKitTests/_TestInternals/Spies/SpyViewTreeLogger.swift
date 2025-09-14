
@testable import SwiftUIViewTreeKit

final class SpyViewTreeLogger: ViewTreeLoggerProtocol {
    nonisolated(unsafe) var hasBeenCalled = false

    func logChangesOf(node: SwiftUIViewTreeKit.TreeNode, previousNodeValue: String) {
        hasBeenCalled = true
    }
}
