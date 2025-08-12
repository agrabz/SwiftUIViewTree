import SwiftUI

struct ItemsView: View {
    @State private var isPopoverPresented = false

    let tree: Tree

    var body: some View {
        VStack {
            Button { //TODO: there's a performance issue here (the more you're zoomed in the worse), every time the button is tapped, the whole view is redrawn
                isPopoverPresented.toggle()
            } label: {
                NodeView(
                    label: tree.parentNode.label,
                    type: tree.parentNode.type,
                    value: String(tree.parentNode.value.prefix(20)) // A memory address is being changed in one of the first parents, but with the prefix approach it never gets redrawn, so it is not visible in the UI.
                )
                    .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                        [self.tree.parentNode.id: anchor]
                    }
            }
            .popover(isPresented: $isPopoverPresented) {
                NodePopover(node: tree.parentNode)
            }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ItemsView(tree: child)
                }
            }
        }
    }
}
