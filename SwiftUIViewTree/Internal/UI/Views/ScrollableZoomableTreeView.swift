import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0
    @State private var itemsViewSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var hasScrolledToCenter: Bool = false
    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
        GeometryReader { scrollProxy in
            ScrollViewReader { scrollViewReader in
                ScrollView([.vertical, .horizontal]) {
                    ZStack { //ZStack is not used anymore but for some reason with it the performance is much better, so keeping it for now
                        TreeView(tree: $tree)
                            .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                                LinesView(
                                    parentTree: self.tree,
                                    nodeCenters: nodeCenters
                                )
                            }
                            .scaleEffect(max(totalZoom + currentZoom, 0.1)) // Prevent flipping by clamping scale
                            .background(
                                GeometryReader { itemsProxy in
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
                                    .onAppear {
                                        self.itemsViewSize = itemsProxy.size
                                        self.scrollViewSize = scrollProxy.size
                                        self.updateInitialZoom()
                                    }
                                    //                                        .onChange(of: itemsProxy.size) { _, _ in
                                    //                                            self.itemsViewSize = itemsProxy.size
                                    //                                            self.updateInitialZoom()
                                    //                                        }
                                }
                            )
                            // Hidden anchor at center
                            .id("centerAnchor") //is this at all then needed? can't we just use the sizes below?
                            .position(x: itemsViewSize.width / 2, y: itemsViewSize.height / 2)
                    }
                }
                .onAppear {
                    //                    self.scrollViewSize = scrollProxy.size
                    self.itemsViewSize = scrollProxy.size
                    self.scrollViewSize = scrollProxy.size

                    Task {
                        updateInitialZoom()
                        scrollToCenterIfNeeded(scrollViewReader: scrollViewReader)
                    }
                    //                }
                    //                .onChange(of: itemsViewSize) { _, _ in
                    //                    Task {
                    //                        scrollToCenterIfNeeded(scrollViewReader: scrollViewReader)
                    //                    }
                }
            }
        }
        .onAppear {
            print("Appear: \(Date())")
        }
        .simultaneousGesture(
            StatefulMagnifyGesture(
                currentZoom: $currentZoom,
                totalZoom: $totalZoom
            )
        )
        //        .background(
        //            LinearGradient(
        //                gradient:
        //                    Gradient(
        //                        colors: [
        //                            .blue,
        //                            .teal
        //                        ]
        //                    ),
        //                startPoint: .topLeading,
        //                endPoint: .bottomTrailing
        //            )
        //        )
    }


    private func updateInitialZoom() {
        guard
            itemsViewSize.width > 0,
            itemsViewSize.height > 0,
            scrollViewSize.width > 0,
            scrollViewSize.height > 0
        else {
            return
        }
        let scaleX = scrollViewSize.width / itemsViewSize.width
        let scaleY = scrollViewSize.height / itemsViewSize.height
        let minScale = min(scaleX, scaleY, 1.0) // Don't zoom in by default
        if abs(totalZoom - minScale) > 0.01 {
            totalZoom = minScale
        }
    }

    private func scrollToCenterIfNeeded(scrollViewReader: ScrollViewProxy) {
        guard
            !hasScrolledToCenter,
            itemsViewSize.width > 0,
            itemsViewSize.height > 0
        else {
            return
        }
        scrollViewReader.scrollTo("centerAnchor", anchor: .center)
        hasScrolledToCenter = true
    }
}
