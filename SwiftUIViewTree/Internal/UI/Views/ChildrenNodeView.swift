import SwiftUI

struct ChildrenNodeView: View {
    let children: [Tree]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(children, id: \.parentNode.id) { child in
                TreeView(
                    tree: child
//                    tree: .init(
//                        get: {
//                            child
//                        }, set: { newValue in
//                            if let index = children.firstIndex { child in
//                                child.parentNode.id == newValue.parentNode.id
//                            } {
//                                children[index] = newValue
//                            }
//                        }
//                    )
                )
            }
        }
    }
}
