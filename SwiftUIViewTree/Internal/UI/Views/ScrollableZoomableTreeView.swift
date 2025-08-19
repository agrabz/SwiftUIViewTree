import SwiftUI

struct ScrollableZoomableTreeView: View {
//    @GestureState private var magnifyBy = 1.0
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0
    @State private var scaleAnchor: UnitPoint = .center
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
                .scaleEffect(max(totalZoom + currentZoom, 0.1), anchor: scaleAnchor) // Prevent flipping by clamping scale
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
                    //                    StatefulMagnifyGesture(
                    //                        currentZoom: $currentZoom,
                    //                        totalZoom: $totalZoom
                    //                    )
                    MagnifyGesture()
//                        .updating($magnifyBy) { value, state, _ in
//                            state = value.magnification
//                        }
                                            .onChanged { value in
                                                scaleAnchor = value.startAnchor
                                                currentZoom = value.magnification - 1
                                            }
                                            .onEnded { value in
                                                totalZoom += currentZoom
                                                currentZoom = 0
                                            }
                )
        }
        .onAppear {
            print("Appear: \(Date())")
        }
    }
}
