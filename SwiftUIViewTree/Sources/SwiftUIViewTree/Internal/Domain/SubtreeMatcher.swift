
@MainActor
enum SubtreeMatcher {
    static func findMatchingSubtree(in root: Tree, matching target: Tree) -> (changed: Tree, original: Tree)? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if areSubtreesEqual(current, target) {
                return (changed: current, original: target)
            }

            queue.append(contentsOf: current.children)
        }

        return nil
    }
}

private extension SubtreeMatcher {
    static func areSubtreesEqual(_ lhs: Tree, _ rhs: Tree) -> Bool {
        guard
            lhs.parentNode.label == rhs.parentNode.label,
            lhs.parentNode.type == rhs.parentNode.type
        else {
            return false
        }

        for (leftChild, rightChild) in zip(lhs.children, rhs.children) {
            if !areSubtreesEqual(leftChild, rightChild) {
                return false
            }
        }

        return true
    }
}
