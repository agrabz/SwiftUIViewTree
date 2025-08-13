import SwiftUI

struct TreeView: View {

    let tree: Tree

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: tree.parentNode,
            )

            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    TreeView(tree: child)
                }
            }
        }
    }
}
