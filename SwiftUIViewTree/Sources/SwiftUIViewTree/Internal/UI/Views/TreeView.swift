import SwiftUI

struct TreeView: View {
    @State private var collapsedNodesStore = CollapsedNodesStore.shared

    @Binding var tree: Tree

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                HStack(alignment: .top) {
                    asd(actualTree: tree)
                }
                .fixedSize()
            }

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    asd(actualTree: child)
                }
            }
            .fixedSize()

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ForEach(child.children, id: \.parentNode.id) { grandchild in
                        asd(actualTree: grandchild)
                    }
                }
            }
            .fixedSize()

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ForEach(child.children, id: \.parentNode.id) { grandchild in
                        ForEach(grandchild.children, id: \.parentNode.id) { greatGrandChild in
                            asd(actualTree: greatGrandChild)
                        }
                    }
                }
            }
            .fixedSize()
        }
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
