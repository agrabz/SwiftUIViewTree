import SwiftUI

struct ParentNodeView: View {
    @State private var isPopoverPresented = false
    let parentNode: TreeNode

    var body: some View {
        Button { //TODO: there's a performance issue here (the more you're zoomed in the worse), every time the button is tapped, the whole view is redrawn
            isPopoverPresented.toggle()
        } label: {
            NodeView(
                label: parentNode.label,
                type: parentNode.type,
                value: String(parentNode.value.prefix(20)), // A memory address is being changed in one of the first parents, but with the prefix approach it never gets redrawn, so it is not visible in the UI.
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
        }
        .popover(isPresented: $isPopoverPresented) {
            NodePopover(node: parentNode)
        }
    }
}
