import Observation

@MainActor
@Observable
final class Tree {
    var parentNode: TreeNode
    var children: [Tree]

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.parentNode = node
        self.children = children
    }

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
}

extension Tree: @MainActor CustomStringConvertible {
    var description: String {
        var description = parentNode.description
        for child in children {
            description += "\n" + "-- " + child.description
        }
        return description
    }
}
