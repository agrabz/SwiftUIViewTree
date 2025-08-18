import SwiftUI

struct ParentNodeView: View {
    @Environment(\.treeCoordinator) var treeCoordinator: TreeCoordinator
    @Binding var parentNode: TreeNode

    var body: some View {
        NodeView(
            node: $parentNode
        )
        .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
            [parentNode.id: anchor]
        }
        .onTapGesture {
            treeCoordinator.popover = .node(self.parentNode)
        }
    }
}
