
import SwiftUI

struct TreeView: View {
    @Binding var tree: Tree

    var body: some View {
        VStack {
            mainNode()

            allOtherNodes()
        }
    }

    func mainNode() -> some View {
        ParentNodeView(
            parentNode: $tree.parentNode
        )
    }

    func allOtherNodes() -> some View {
        HStack(alignment: .top) {
            branch(of: .originalView)

            branch(of: .modifiedView)
        }
    }

    func branch(of rootNode: RootNodeType) -> some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.children[rootNode.index].parentNode //TODO: introduce a MainTree type which guarantees to have an original and a modified branch instead of this crashable approach
            )

            graph(of: rootNode)
        }
    }

    func graph(of rootNode: RootNodeType) -> some View {
        //TODO: with this approach children may not be under their parent, which can look weird
        ForEach(TreeLeveler.getAllTreeLevels(of: tree.children[rootNode.index]), id: \.self) { treeLevels in
            HStack(alignment: .top) {
                ForEach(treeLevels, id: \.parentNode.id) { treeInActualLevel in
                    if CollapsedNodesStore.shared.isCollapsed(nodeID: treeInActualLevel.parentNode.id) == false {
                        childrenNodes(of: treeInActualLevel)
                    }
                }
            }
            .fixedSize()
        }
    }

    func childrenNodes(of parentTree: Tree) -> some View {
        ColumnedGrid(source: parentTree.children, numberOfColumns: 4) { actualTree in
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
