import Observation

@MainActor
@Observable
final class Tree: @MainActor Equatable {
    var parentNode: TreeNode
    var children: [Tree]

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.parentNode = node
        self.children = children
    }

    static func == (lhs: Tree, rhs: Tree) -> Bool {
        lhs.parentNode == rhs.parentNode &&
        lhs.children == rhs.children
    }
}
