import SwiftUI

struct TreeView: View {
    @Binding var tree: Tree
    @State private var collapsedNodesStore: CollapsedNodesStore = CollapsedNodesStore.shared

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
