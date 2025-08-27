import SwiftUI

struct ParentNodeView: View {
    @State var dummy = false //TODO: without this the first isRecomputing updates every node color, not just the ones that got a new value. there used to be another state here for navigation, hence its location
    @Binding var parentNode: TreeNode

    var body: some View {

        if parentNode.label == "modifiers" && isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("ParentNodeView")
            let _ = Self._printChanges()
            let _ = print()
        }

        NodeView(node: $parentNode)
            .simultaneousGesture(
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
