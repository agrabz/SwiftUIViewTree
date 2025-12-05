import SwiftUI

struct ParentNodeView: View {
    @Binding var parentNode: TreeNode

    var body: some View {
        NodeView(node: $parentNode)
            .gesture(
                CollapseNodeGesture(
                    node: $parentNode
                )
                .exclusively(
                    before: PrintNodeShortenedDetailsGesture(node: $parentNode)
                )
            )
            .gesture(PrintNodeFullDetailsGesture(node: $parentNode))
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
    }
}
