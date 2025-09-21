import Observation

@MainActor
@Observable
final class Tree: @MainActor Equatable {

    subscript(serialNumber: Int) -> TreeNode? {
        if parentNode.serialNumber == serialNumber {
            return parentNode
        } else {
            for child in children {
                if let found = child[serialNumber] {
                    return found
                }
            }
            return nil
        }
    }

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
