import SwiftUI

struct ParentNodeView: View {
    @Binding var parentNode: TreeNode

    var body: some View {
        NodeView(
            node: $parentNode
        )
        .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
            [parentNode.id: anchor]
        }
        .contextMenu {
            NodeContextMenuContent(node: parentNode)
        }
    }
}
