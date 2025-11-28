import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0
    @State private var itemsViewSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var hasScrolledToCenter: Bool = false
    @State private var offset: CGSize = .zero
    @State var tree: Tree

    private var magnifyGesture: StatefulMagnifyGesture {
        StatefulMagnifyGesture(
            currentZoom: $currentZoom,
            totalZoom: $totalZoom
        )
    }
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
        GeometryReader { scrollProxy in
            ScrollViewReader { scrollViewReader in
                ScrollView([.vertical, .horizontal]) {
                    ZStack {
                        TreeView(tree: $tree)
                            .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                                LinesView(
                                    parentTree: self.tree,
                                    nodeCenters: nodeCenters
                                )
                            }
                            .offset(offset)
//                            .scaleEffect(max(totalZoom + currentZoom, 0.1)) // Prevent flipping by clamping scale
                            .scaleEffect(getScale()) // Prevent flipping by clamping scale
                            .background(
                                GeometryReader { itemsProxy in
                                    Color.clear
                                        .onAppear {
                                            self.itemsViewSize = itemsProxy.size
                                            self.scrollViewSize = scrollProxy.size
                                            self.updateInitialZoom()
                                        }
                                        .onChange(of: itemsProxy.size) { _, _ in
                                            self.itemsViewSize = itemsProxy.size
                                            self.updateInitialZoom()
                                        }
                                }
                            )
                        // Hidden anchor at center
                        Color.clear
                            .frame(width: 1, height: 1)
                            .id("centerAnchor")
                            .position(x: itemsViewSize.width / 2, y: itemsViewSize.height / 2)
                    }
                }
                .onAppear {
                    self.scrollViewSize = scrollProxy.size
                    self.updateInitialZoom()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scrollToCenterIfNeeded(scrollViewReader: scrollViewReader)
                    }
                }
                .onChange(of: itemsViewSize) { _, _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scrollToCenterIfNeeded(scrollViewReader: scrollViewReader)
                    }
                }
            }
        }
        .simultaneousGesture(
            magnifyGesture
        )
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
    }

    private func updateInitialZoom() {
        guard itemsViewSize.width > 0, itemsViewSize.height > 0, scrollViewSize.width > 0, scrollViewSize.height > 0 else { return }
        let scaleX = scrollViewSize.width / itemsViewSize.width
        let scaleY = scrollViewSize.height / itemsViewSize.height
        let minScale = min(scaleX, scaleY, 1.0) // Don't zoom in by default
        if abs(totalZoom - minScale) > 0.01 {
            totalZoom = minScale
        }
    }

    private func scrollToCenterIfNeeded(scrollViewReader: ScrollViewProxy) {
        guard !hasScrolledToCenter, itemsViewSize.width > 0, itemsViewSize.height > 0 else { return }
        scrollViewReader.scrollTo("centerAnchor", anchor: .center)
        hasScrolledToCenter = true
    }
}

private extension ScrollableZoomableTreeView {
    func getScale() -> CGFloat {
        currentZoom + totalZoom
    }
}
