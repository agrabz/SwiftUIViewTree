import SwiftUI

struct ParentNodeView: View {
    @Binding var parentNode: TreeNode

    var body: some View {

        if parentNode.label == "modifiers" && isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("ParentNodeView")
            let _ = Self._printChanges()
            let _ = print()
        }

        NodeView(node: $parentNode)
            .gesture(
                CollapseNodeGesture(
                    node: $parentNode
                )
                .exclusively(
                    before: PrintNodeDetailsGesture(
                        node: $parentNode
                    )
                )
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
    }
}
