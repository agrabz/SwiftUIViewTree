import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State var tree: Tree

    var body: some View {
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
                    .padding(.all, 200)
            }
        }
        .ignoresSafeArea()
    }
}

