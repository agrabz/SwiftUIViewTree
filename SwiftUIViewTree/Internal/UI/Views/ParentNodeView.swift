import SwiftUI
import os.log

struct ParentNodeView: View {
    @State private var isPopoverPresented = false
    let parentNode: TreeNode

    var body: some View {
        Button {
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
