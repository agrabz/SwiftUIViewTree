import SwiftUI

struct TreeView: View {
    @Binding var tree: Tree

    var body: some View {
        VStack {
            NodeView(
                node: $tree.parentNode
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [tree.parentNode.id: anchor]
            }

            ChildrenNodeView(children: $tree.children)
        }
    }
}
