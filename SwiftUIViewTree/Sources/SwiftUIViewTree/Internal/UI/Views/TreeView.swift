import SwiftUI

struct TreeView: View, @MainActor Equatable {
    static func == (lhs: TreeView, rhs: TreeView) -> Bool {
        lhs.tree.parentNode.value == rhs.tree.parentNode.value
    }

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
            .equatable()

            if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                ChildrenNodeView(
                    children: $tree.children
                )
                .equatable()
            }
        }
    }
}
