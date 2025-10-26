
@MainActor
enum SubtreeMatcher {
    static func findMatchingSubtree(in root: Tree, matching target: Tree) -> (changed: Tree, original: Tree)? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if current == target {
                return (changed: current, original: target)
            }

            queue.append(contentsOf: current.children)
        }

        return nil
    }
}
