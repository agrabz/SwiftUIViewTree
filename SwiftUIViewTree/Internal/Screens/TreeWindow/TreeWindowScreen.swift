import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    let originalContent: Content

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    switch TreeContainer.shared.uiState {
                        case .computingTree:
                            ViewTreeTraversalProgressView()
                        case .treeComputed(let computedUIState):
                            TreeView(tree: computedUIState.treeBreakDownOfOriginalContent)
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
