import SwiftUI

struct TreeView: View {
    let tree: Tree

    var body: some View {
        if tree.parentNode.label == "isActive" {
            let _ = print("--TreeView isActive")
            let _ = Self._printChanges()
            let _ = print("\n")
        }

        VStack {
            ParentNodeView(parentNode: tree.parentNode)

            ChildrenNodeView(children: tree.children)
        }
    }
}
