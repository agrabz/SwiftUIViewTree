import SwiftUI

struct TreeView: View {
    let tree: Tree

    var body: some View {
        if tree.parentNode.label == "isActive" {
            let _ = print("--TreeView isActive")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if tree.parentNode.label == "anyTextModifier" {
            let _ = print("--TreeView anyTextModifier")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if tree.parentNode.value == "anyTextModifier(SwiftUI.BoldTextModifier" {
            let _ = print("--TreeView anyTextModifier(SwiftUI.BoldTextModifier")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if tree.parentNode.label == "modifiers" {
            let _ = print("--TreeView modifiers")
            let _ = Self._printChanges()
            let _ = print("\n")
        }

        if tree.parentNode.label == "label" {
            let _ = print("-TreeView label")
            let _ = Self._printChanges()
            let _ = print("\n")
        }

        VStack {
            NodeView(
//                node: tree.parentNode
                label: tree.parentNode.label,
                type: tree.parentNode.type,
                value: tree.parentNode.value,
                id: tree.parentNode.id
            )
#warning("place back to NodeView?")

            ChildrenNodeView(children: tree.children)
        }
    }
}
