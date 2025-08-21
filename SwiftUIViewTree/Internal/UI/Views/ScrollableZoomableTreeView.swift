import SwiftUI

struct ScrollableZoomableTreeView: View {
    private static let minimumZoom: CGFloat = 0.1

    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = Self.minimumZoom
    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            TreeView(tree: $tree)
                .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                    LinesView(
                        parentTree: self.tree,
                        nodeCenters: nodeCenters
                    )
                }
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
        }
        .onAppear {
            print("Appear: \(Date())")
        }
    }
}
