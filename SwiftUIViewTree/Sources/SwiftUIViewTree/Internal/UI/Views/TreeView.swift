import SwiftUI

struct TreeView: View {
    @State private var collapsedNodesStore = CollapsedNodesStore.shared

    @Binding var tree: Tree

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            ForEach(self.treeLevels(), id: \.self) { treeLevels in  //TODO: better names?
                HStack(alignment: .top) {
                    ForEach(treeLevels, id: \.parentNode.id) { tree in
                        if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                            asd(actualTree: tree)
                        }
                    }
                }
                .fixedSize()
            }
        }
    }

    func treeLevels() -> [[Tree]] {
        var levels: [[Tree]] = []
        var currentLevel: [Tree] = [tree]

        while !currentLevel.isEmpty {
            levels.append(currentLevel)

            // Build next level by collecting all children
            var nextLevel: [Tree] = []
            for node in currentLevel {
                nextLevel.append(contentsOf: node.children)
            }
            currentLevel = nextLevel
        }

        return levels
    }

    func asd(actualTree: Tree) -> some View { //TODO: better names
        ForEach(actualTree.children, id: \.parentNode.id) { actualTree in
            ParentNodeView(
                parentNode: .init(
                    get: {
                        actualTree.parentNode
                    },
                    set: { newValue in
                        if let index = actualTree.children.firstIndex(
                            where: { actualTreeCandidate in
                                actualTreeCandidate.parentNode.id == newValue.id
                            }
                        ) {
                            actualTree.children[index].parentNode = newValue
                        }
                    }
                )
            )
        }
    }
}
