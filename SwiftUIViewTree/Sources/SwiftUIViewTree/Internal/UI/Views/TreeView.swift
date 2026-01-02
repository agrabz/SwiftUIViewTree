import SwiftUI

struct TreeView: View {
    @State private var collapsedNodesStore = CollapsedNodesStore.shared

    @Binding var tree: Tree

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            ForEach(self.treeLevels(), id: \.self) { a in
                HStack(alignment: .top) {
                    ForEach(a, id: \.parentNode.id) { b in
                        if collapsedNodesStore.isCollapsed(nodeID: b.parentNode.id) == false {
                            asd(actualTree: b)
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

    func asd(actualTree: Tree) -> some View {
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
