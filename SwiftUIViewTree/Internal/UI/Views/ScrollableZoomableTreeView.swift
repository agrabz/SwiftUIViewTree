import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State private var currentZoom: CGFloat = StatefulMagnifyGesture.idleZoom
    @State private var totalZoom: CGFloat = StatefulMagnifyGesture.minZoom
    @State private var offset: CGSize = .zero
    @State var tree: Tree

    var body: some View {
        TreeView(tree: $tree)
            .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                LinesView(
                    parentTree: self.tree,
                    nodeCenters: nodeCenters
                )
            }
            .offset(offset)
            .scaleEffect(currentZoom + totalZoom)
            .background(
                LinearGradient(
                    gradient:
                        Gradient(
                            colors: [
                                .blue,
                                .teal
                            ]
                        ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .simultaneousGesture(
                StatefulMagnifyGesture(
                    currentZoom: $currentZoom,
                    totalZoom: $totalZoom
                )
            )
            .simultaneousGesture(
                DragToScrollGesture(
                    offset: $offset,
                    scale: currentZoom + totalZoom
                )
            )
    }

    func getScale() -> CGFloat {
        currentZoom + totalZoom
    }
}
