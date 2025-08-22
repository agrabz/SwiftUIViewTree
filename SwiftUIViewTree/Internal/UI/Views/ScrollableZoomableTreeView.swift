import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State private var currentZoom: CGFloat = StatefulMagnifyGesture.idleZoom
    @State private var totalZoom: CGFloat = StatefulMagnifyGesture.minZoom
    @State private var offset: CGSize = .zero
    @State var tree: Tree

    private var magnifyGesture: StatefulMagnifyGesture {
        StatefulMagnifyGesture(
            currentZoom: $currentZoom,
            totalZoom: $totalZoom
        )
    }

    private var dragGesture: DragToScrollGesture {
        DragToScrollGesture(
            offset: $offset,
            scale: getScale()
        )
    }

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        if isPerformanceLoggingEnabled {
            print("ScrollableZoomableTreeView Init: \(Date())")
        }
    }

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
            .frame( //by providing an explicit frame the performance of gesture attaching and readiness is improved
                width: UIScreen.main.bounds.width * UIConstants.ScreenRatioOf.viewTree,
                height: UIScreen.main.bounds.height * UIConstants.ScreenRatioOf.viewTree
            )
            .gesture(magnifyGesture)
            .simultaneousGesture(dragGesture)
            .onAppear {
                if isPerformanceLoggingEnabled {
                    print("ScrollableZoomableTreeView Appeared: \(Date())")
                }
            }
    }
}

private extension ScrollableZoomableTreeView {
    func getScale() -> CGFloat {
        currentZoom + totalZoom
    }
}
