import SwiftUI

struct ScrollableZoomableTreeView: View {
    private static let minimumZoom: CGFloat = 0.3

    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = Self.minimumZoom
    @State private var offset: CGSize = .zero
    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
            TreeView(tree: $tree)
                .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                    LinesView(
                        parentTree: self.tree,
                        nodeCenters: nodeCenters
                    )
                }
                .scaleEffect(getScale()) // Prevent flipping by clamping scale
                .offset(offset)
                .scaleEffect(max(totalZoom + currentZoom, Self.minimumZoom)) // Prevent flipping by clamping scale
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
        .onAppear {
            print("Appear: \(Date())")
        }
    }

    func getScale() -> CGFloat {
        max(totalZoom + currentZoom, Self.minimumZoom)
    }
}
