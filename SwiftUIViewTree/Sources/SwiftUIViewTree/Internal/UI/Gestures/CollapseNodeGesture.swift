
import SwiftUI

struct CollapseNodeGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        TapGesture(count: 3)
            .onEnded { _ in
                guard self.node.isParent else { return }

                withAnimation {
                    CollapsedNodesStore.shared.toggleCollapse(nodeID: self.node.id)
                }
            }
    }
}
