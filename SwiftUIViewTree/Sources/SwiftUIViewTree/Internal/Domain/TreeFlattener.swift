
@MainActor
enum TreeFlattener {
    static func flatten(_ treeToFlatten: Tree) -> [TreeNode] {
        var flattenedTree: [TreeNode] = []

        flattenedTree.append(treeToFlatten.parentNode)

        for child in treeToFlatten.children {
            flattenedTree.append(
                contentsOf: flatten(child)
            )
        }

        return flattenedTree
    }
}
