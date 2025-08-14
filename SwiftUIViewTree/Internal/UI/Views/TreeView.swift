import SwiftUI

struct TreeView: View {
    let tree: Tree

    var body: some View {
        VStack {
            ParentNodeView(parentNode: tree.parentNode)

            ChildrenNodeView(children: tree.children)
        }
    }
}
