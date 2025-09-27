import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeContainer = TreeContainer.shared

    let originalContent: Content

    var body: some View {
        HStack {
            originalContent
                .frame(width: UIScreen.main.bounds.width * UIConstants.ScreenRatioOf.originalContent)
                .disabled(TreeContainer.shared.isRecomputing)
                .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

            NavigationStack { //TODO: might not be needed anymore, was added originally to support navigation in the tree, namely .popover. removing this will cause a weird look during the initial computation
                switch treeContainer.uiState {
                    case .computingTree:
                        ViewTreeTraversalProgressView()
                            .onDisappear {
                                if isPerformanceLoggingEnabled {
                                    print("ViewTreeTraversalProgressView disappeared at \(Date())")
                                }
                            }
                    case .treeComputed(let computedUIState):
                        if isViewPrintChangesEnabled {
                            let _ = print()
                            let _ = print("ChildrenNodeView")
                            let _ = Self._printChanges()
                            let _ = print()
                        }

                        ZStack {
                            ScrollableZoomableTreeView(
                                tree: computedUIState.treeBreakDownOfOriginalContent
                            )
                            .equatable()
                            .disabled(TreeContainer.shared.isRecomputing)
                            .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

                            if TreeContainer.shared.isRecomputing {
                                ViewTreeTraversalProgressView()
                            }
                        }
                        .onAppear {
                            if isPerformanceLoggingEnabled {
                                print("ScrollableZoomableTreeView appeared from TreeWindowScreen at \(Date())")
                            }
                        }
                }
            }
            .frame(width: UIScreen.main.bounds.width * UIConstants.ScreenRatioOf.viewTree)
        }
    }
}
