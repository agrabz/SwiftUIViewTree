import SwiftUI

struct TreeView: View {
    @State private var collapsedNodesStore = CollapsedNodesStore.shared

    @Binding var tree: Tree

    var body: some View {
        if tree.parentNode.label == "modifiers" && isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("TreeView")
            let _ = Self._printChanges()
            let _ = print()
        }

        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                ChildrenNodeView(
                    children: $tree.children
                )
            }
        }
    }
}
