import SwiftUI

struct TreeWindowScreen<Content: View>: View {
//    @State var viewModel: TreeWindowViewModel<Content>
    let originalContent: Content
    var treeBreakDownOfOriginalContent: Tree

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
//                    switch viewModel.uiModel {
//                        case .computingTree:
//                            ViewTreeTraversalProgressView()
//                        case .treeComputed(let computedUIState):
                            TreeView(tree: treeBreakDownOfOriginalContent)
//                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
