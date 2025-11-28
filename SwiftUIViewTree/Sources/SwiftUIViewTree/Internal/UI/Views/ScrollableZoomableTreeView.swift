import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State var tree: Tree

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
                    .onAppear {
                        if isPerformanceLoggingEnabled {
                            print("ScrollableZoomableTreeView Appeared: \(Date())")
                        }
                    }
                    .padding(.all, 200)
            }
        }
        .ignoresSafeArea()
    }
}

