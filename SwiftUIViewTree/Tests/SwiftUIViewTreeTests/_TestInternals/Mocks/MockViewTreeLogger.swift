
@testable import SwiftUIViewTree

struct MockViewTreeLogger: ViewTreeLoggerProtocol {
    func logChangesOf(node: SwiftUIViewTree.TreeNode, previousNodeValue: String) { }
}
