
@testable import SwiftUIViewTree

extension Tree {
    static func createMock(
        parentNode: TreeNode = .createMock(),
        children: [Tree] = []
    ) -> Tree {
        Tree(
            node: parentNode,
            children: children
        )
    }
}
