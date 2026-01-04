
@MainActor
enum TreeLeveler {
    static func getAllTreeLevels(of tree: Tree) -> [[Tree]] {
        var allTreeLevels = [[Tree]]()
        var currentLevelOfTrees = [tree]

        while currentLevelOfTrees.isNotEmpty {
            allTreeLevels.append(currentLevelOfTrees)

            var nextLevelOfTrees = [Tree]()

            for currentLevelTree in currentLevelOfTrees {
                if CollapsedNodesStore.shared.isCollapsed(nodeID: currentLevelTree.parentNode.id) {
                    continue
                }

                nextLevelOfTrees.append(contentsOf: currentLevelTree.children)
            }

            currentLevelOfTrees = nextLevelOfTrees
        }

        return allTreeLevels
    }
}

