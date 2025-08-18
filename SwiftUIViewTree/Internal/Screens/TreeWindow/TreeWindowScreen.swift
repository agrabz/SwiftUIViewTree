import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    let originalContent: Content

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)
                    .disabled(TreeContainer.shared.isRecomputing)
                    .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

                NavigationStack { //TODO: might not be needed anymore, was added originally to support navigation in the tree, namely .popover, but now menu is used. removing this will cause a weird look during the initial computation
                    switch TreeContainer.shared.uiState {
                        case .computingTree:
                            ViewTreeTraversalProgressView()
                        case .treeComputed(let computedUIState):
                            ZStack {
                                ScrollableZoomableTreeView(
                                    tree: computedUIState.treeBreakDownOfOriginalContent
                                )
                                .disabled(TreeContainer.shared.isRecomputing)
                                .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

                                if TreeContainer.shared.isRecomputing {
                                    ViewTreeTraversalProgressView()
                                }
                            }
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
