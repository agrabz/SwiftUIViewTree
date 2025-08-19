import SwiftUI

struct TreeView: View {
    @Binding var tree: Tree

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack {
                ParentNodeView(
                    parentNode: $tree.parentNode
                )
                
                ChildrenNodeView(
                    children: $tree.children
                )
            }
        }
    }
}
