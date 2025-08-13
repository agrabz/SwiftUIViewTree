import SwiftUI

struct ChildrenView: View {
    let children: [Tree]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(children, id: \.parentNode.id) { child in
                TreeView(tree: child)
            }
        }
    }
}
