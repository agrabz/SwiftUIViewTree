import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State var showTree: Bool

    let originalContent: Content

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    originalContent
                        .frame(width: showTree ? (proxy.size.width * UIConstants.ScreenRatioOf.originalContent) : proxy.size.width)

                    if showTree {
                        viewFor(uiState: treeWindowViewModel.uiState)
                            .frame(width: proxy.size.width * UIConstants.ScreenRatioOf.viewTree) //TODO: this should always be the 3/4 of the screen even if we use it on a subview
                    }
                }
                .transition(.move(edge: .trailing))

                ShouldShowTreeButton(shouldShowTree: self.$showTree)
                    .position(
                        x: proxy.size.width - 50,
                        y: 50
                    )
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    @ViewBuilder
    private func viewFor(uiState: TreeWindowUIModel) -> some View {
        switch treeWindowViewModel.uiState {
            case .computingTree:
                ViewTreeTraversalProgressView()
            case .treeComputed(let computedUIState):
                ZStack {
                    ScrollableZoomableTreeView(
                        tree: computedUIState.treeBreakDownOfOriginalContent
                    )

                    if TreeWindowViewModel.shared.isRecomputing {
                        ViewTreeTraversalProgressView()
                    }
                }
        }
    }
}
