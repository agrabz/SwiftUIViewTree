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
            ParentNodeView(parentNode: tree.parentNode)

            ChildrenNodeView(children: tree.children)
        }
    }
}
