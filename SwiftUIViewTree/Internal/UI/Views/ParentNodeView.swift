import SwiftUI

struct ParentNodeView: View {
    @Binding var parentNode: TreeNode

    var body: some View {
        Menu {
            NodeMenuContent(node: parentNode)
        } label: {
            NodeView(
                node: $parentNode
            )
        }
        .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
            [parentNode.id: anchor]
        }
    }
}
