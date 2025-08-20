import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
        TreeView(tree: $tree)
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
            .onAppear {
                print("Appear: \(Date())")
            }
    }
}
