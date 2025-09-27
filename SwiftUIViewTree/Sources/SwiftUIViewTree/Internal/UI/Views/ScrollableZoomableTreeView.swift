import SwiftUI

struct ScrollableZoomableTreeView: View, @MainActor Equatable {
    static func == (lhs: ScrollableZoomableTreeView, rhs: ScrollableZoomableTreeView) -> Bool {
        lhs.tree.parentNode.value == rhs.tree.parentNode.value
    }

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
        if isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("ScrollableZoomableTreeView")
            let _ = Self._printChanges()
            let _ = print()
        }

        TreeView(tree: $tree)
            .equatable()
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

                //TODO: without this change, or by manual zooming before the first interaction the whole tree will be re-rendered. has to be resolved, probably the problem is with the Equatable conformance of the views
                self.offset = .init(width: 1, height: 1)
            }
    }
}

private extension ScrollableZoomableTreeView {
    func getScale() -> CGFloat {
        currentZoom + totalZoom
    }
}
