import SwiftUI

struct TreeView: View {
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

            if tree.parentNode.isCollapsed == false {
                ChildrenNodeView(
                    children: $tree.children
                )
            }
        }
    }
}
