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

extension Tree: @MainActor Equatable {
    static func == (_ lhs: Tree, _ rhs: Tree) -> Bool {
        guard
            lhs.parentNode.label == rhs.parentNode.label,
            lhs.parentNode.type == rhs.parentNode.type,
            lhs.parentNode.descendantCount == rhs.parentNode.descendantCount
        else {
            return false
        }

        //TODO: zip might not be a good idea here because of mismatching number of children in rhs and lhs
        for (leftChild, rightChild) in zip(lhs.children, rhs.children) {
            if leftChild != rightChild {
                return false
            }
        }

        return true
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
