import SwiftUI

struct ParentNodeView: View {
    @State var dummy = false //TODO: without this the first isRecomputing updates every node color, not just the ones that got a new value. there used to be another state here for navigation, hence its location
    @Binding var parentNode: TreeNode

    var body: some View {
//        Menu {
//            NodeMenuContent(node: parentNode)
//        } label: {
            NodeView(
                node: $parentNode
            )
//        }
        .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
            [parentNode.id: anchor]
        }
    }
}
