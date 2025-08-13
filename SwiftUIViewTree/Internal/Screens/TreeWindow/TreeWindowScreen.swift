import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    let originalContent: Content

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    if let treeBreakDownOfOriginalContent = TreeContainer.shared.tree {
                        TreeView(tree: treeBreakDownOfOriginalContent)
                    } else {
                        ViewTreeTraversalProgressView()
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
