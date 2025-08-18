import Observation

@Observable
final class Tree: /*CustomStringConvertible,*/ Equatable {
    var parentNode: TreeNode
    var children: [Tree] // TODO: parents with only one child should be merged with their children

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.parentNode = node
        self.children = children
    }

    static func == (lhs: Tree, rhs: Tree) -> Bool {
        lhs.parentNode == rhs.parentNode
    }
}
