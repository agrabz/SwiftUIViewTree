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
                ChildrenNodeView(
                    children: $tree.children
                )
                .fixedSize()
            }

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ForEach(child.children, id: \.parentNode.id) { grandchild in
                        ParentNodeView(
                            parentNode: .init(
                                get: {
                                    grandchild.parentNode
                                },
                                set: { newValue in
                                    if let index = tree.children.firstIndex(
                                        where: { child in
                                            child.parentNode.id == newValue.id
                                        }
                                    ) {
                                        tree.children[index].parentNode = newValue
                                    }
                                }
                            )
                        )
                    }
                }
            }
            .fixedSize()

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ForEach(child.children, id: \.parentNode.id) { grandchild in
                        ForEach(grandchild.children, id: \.parentNode.id) { greatGrandchild in
                            ParentNodeView(
                                parentNode: .init(
                                    get: {
                                        greatGrandchild.parentNode
                                    },
                                    set: { newValue in
                                        if let index = tree.children.firstIndex(
                                            where: { child in
                                                child.parentNode.id == newValue.id
                                            }
                                        ) {
                                            tree.children[index].parentNode = newValue
                                        }
                                    }
                                )
                            )
                        }
                    }
                }
            }
            .fixedSize()
        }
    }
}
