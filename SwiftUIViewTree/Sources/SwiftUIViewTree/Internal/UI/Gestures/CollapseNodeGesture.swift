
import SwiftUI

struct CollapseNodeGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        TapGesture(count: 2) //TODO: change to 3 and 2 should be full detail printing, maybe?
            .onEnded { _ in
                guard self.node.isParent else { return }

                withAnimation {
                    CollapsedNodesStore.shared.toggleCollapse(nodeID: self.node.id)
                }
            }
    }
}
