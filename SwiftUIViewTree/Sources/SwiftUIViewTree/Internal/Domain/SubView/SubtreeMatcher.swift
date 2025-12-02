
@MainActor
enum SubtreeMatcher {
    //TODO: Right now we cannot properly differentiate between subviews that are the same, so we always return the first match. Later it should be adjusted with a @State UUID approach like .notifyViewTreeOnChanges(of: self, id: $id)
    static func findMatchingSubTree(in root: Tree, matching target: Tree) -> SubTree? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if current == target {
                return SubTree(
                    changedSubTree: current,
                    originalSubTree: target
                )
            }

            queue.append(contentsOf: current.children)
        }

        return nil
    }
}
