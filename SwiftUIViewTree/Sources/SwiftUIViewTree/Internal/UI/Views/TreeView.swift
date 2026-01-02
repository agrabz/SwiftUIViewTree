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
                    ForEach(tree.children, id: \.parentNode.id) { child in
                        ParentNodeView(
                            parentNode: .init(
                                get: {
                                    child.parentNode
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
                                    if let index = grandchild.children.firstIndex(
                                        where: { grandchild in
                                            grandchild.parentNode.id == newValue.id
                                        }
                                    ) {
                                        child.children[index].parentNode = newValue
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
                                        if let index = greatGrandchild.children.firstIndex(
                                            where: { greatGrandchild in
                                                greatGrandchild.parentNode.id == newValue.id
                                            }
                                        ) {
                                            grandchild.children[index].parentNode = newValue
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
