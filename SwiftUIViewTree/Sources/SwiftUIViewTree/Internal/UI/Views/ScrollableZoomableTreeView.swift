import SwiftUI
//import Zoomable

struct ScrollableZoomableTreeView: View {
//    @State private var currentZoom: CGFloat = StatefulMagnifyGesture.idleZoom
//    @State private var totalZoom: CGFloat = StatefulMagnifyGesture.minZoom
//    @State private var offset: CGSize = .zero
    @State var tree: Tree

//    private var magnifyGesture: StatefulMagnifyGesture {
//        StatefulMagnifyGesture(
//            currentZoom: $currentZoom,
//            totalZoom: $totalZoom
//        )
//    }
//
//    private var dragGesture: DragToScrollGesture {
//        DragToScrollGesture(
//            offset: $offset,
//            scale: getScale()
//        )
//    }

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

        Zoomable {
            ZStack {
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

                TreeView(tree: $tree)
                    .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                        LinesView(
                            parentTree: self.tree,
                            nodeCenters: nodeCenters
                        )
                    }
                //                .offset(offset)
                //                .scaleEffect(getScale())
                    .onAppear {
                        if isPerformanceLoggingEnabled {
                            print("ScrollableZoomableTreeView Appeared: \(Date())")
                        }
                    }
            }
        }
        .ignoresSafeArea()
//        .gesture(magnifyGesture)
//        .simultaneousGesture(dragGesture)
    }
}

private extension ScrollableZoomableTreeView {
//    func getScale() -> CGFloat {
//        currentZoom + totalZoom
//    }
}
