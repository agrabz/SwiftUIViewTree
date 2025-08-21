import SwiftUI

struct ScrollableZoomableTreeView: View {
    private static let minimumZoom: CGFloat = 0.1

    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = Self.minimumZoom
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
            .scaleEffect(getScale())
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
                DragyGesture(
                    offset: $offset,
                    scale: getScale()
                )
            )
    }

    func getScale() -> CGFloat {
        max(totalZoom + currentZoom, Self.minimumZoom)
    }
}
