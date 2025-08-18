import SwiftUI

struct ParentNodeView: View { //TODO: having this layer makes the scrolling and zooming more laggy. maybe because of the popover?
    @State private var isPopoverPresented = false
    @Binding var parentNode: TreeNode

    var body: some View {
//        Button {
//            isPopoverPresented.toggle()
//        } label: {
            NodeView(
                node: $parentNode
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
            .onTapGesture {
                TreeCoordinator.shared.popover = .node(self.parentNode)
            }
//        }
//        .popover(isPresented: $isPopoverPresented) {
//            NodePopover(node: parentNode)
//        }
    }
}
