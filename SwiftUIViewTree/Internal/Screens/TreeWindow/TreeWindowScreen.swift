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

                NavigationStack {
                    switch TreeContainer.shared.uiState {
                        case .computingTree:
                            ViewTreeTraversalProgressView()
                        case .treeComputed(let computedUIState):
                            ZStack {
                                ScrollableZoomableTreeView(
//                                    tree: .init(get: {
//                                        computedUIState.treeBreakDownOfOriginalContent
//                                    }, set: { newValue in
//                                        computedUIState.treeBreakDownOfOriginalContent = newValue
//                                        //TODO: .treeComputed reassign?
//                                    })
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
