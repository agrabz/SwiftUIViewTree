import SwiftUI
import os.log

struct ParentNodeView: View {
    @State private var isPopoverPresented = false
    let parentNode: TreeNode

    private let logger = Logger(subsystem: "com.sap.ariba.ibx.SwiftUIViewTree", category: "Akos")


    var body: some View {
        if parentNode.label == "isActive" {
            let _ = print("-ParentNodeView isActive")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if parentNode.label == "anyTextModifier" {
            let _ = print("--ParentNodeView anyTextModifier")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if parentNode.value == "anyTextModifier(SwiftUI.BoldTextModifier" {
            let _ = print("--ParentNodeView anyTextModifier(SwiftUI.BoldTextModifier")
            let _ = Self._printChanges()
            let _ = print("\n")
        }
        if parentNode.label == "modifiers" {
            let _ = print("--ParentNodeView modifiers")
            let _ = Self._printChanges()
            let _ = print("\n")
        }

        if parentNode.label == "label" {
            let _ = print("-ParentNodeView label")
            let _ = Self._printChanges()
//            let _ = Self._logChanges()
//            let _ = logger.log("visible?")
            let _ = print("\n")
        }
//
//        if parentNode.label == "anyTextModifier" {
//            let _ = print("-ParentNodeView anyTextModifier")
//            let _ = Self._printChanges()
//        }

        Button { //TODO: there's a performance issue here (the more you're zoomed in the worse), every time the button is tapped, the whole view is redrawn
            isPopoverPresented.toggle()
        } label: {
//            NodeView(
//                label: parentNode.label,
//                type: parentNode.type,
//                value: String(parentNode.value), // A memory address is being changed in one of the first parents, but with the prefix approach it never gets redrawn, so it is not visible in the UI.
//            )
//            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
//                [parentNode.id: anchor]
//            }
        }
        .popover(isPresented: $isPopoverPresented) {
            NodePopover(node: parentNode)
        }
    }
}
