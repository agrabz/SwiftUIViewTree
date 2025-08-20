import SwiftUI

struct ScrollableZoomableTreeView: View {
    private static let minimumZoom: CGFloat = 0.1

    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = Self.minimumZoom
    @State private var scaleAnchor: UnitPoint?

    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            TreeView(tree: $tree)
                .scaleEffect(max(totalZoom + currentZoom, Self.minimumZoom), anchor: scaleAnchor == nil ? .center : scaleAnchor!) // Prevent flipping by clamping scale
                .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                    LinesView(
                        parentTree: self.tree,
                        nodeCenters: nodeCenters
                    )
                }
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
                        totalZoom: $totalZoom,
                        scaleAnchor: $scaleAnchor
                    )
                )
        }
        .onAppear {
            print("Appear: \(Date())")
        }
    }
}
