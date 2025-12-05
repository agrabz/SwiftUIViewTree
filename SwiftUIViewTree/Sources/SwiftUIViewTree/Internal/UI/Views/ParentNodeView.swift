import SwiftUI

struct ParentNodeView: View {
    @Binding var parentNode: TreeNode

    var body: some View {
        NodeView(node: $parentNode)
            .gesture(
                PrintNodeFullDetailsGesture(node: $parentNode)
                    .exclusively(
                        before: CollapseNodeGesture(
                            node: $parentNode
                        )
                        .exclusively(
                            before: PrintNodeShortenedDetailsGesture(node: $parentNode)
                        )
                    )
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
    }
}
