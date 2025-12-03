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
        }
    }
}
