import SwiftUI

struct ChildrenNodeView: View {
    @Binding var children: [Tree]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(children, id: \.parentNode.id) { child in
                ParentNodeView(
                    parentNode: .init(
                        get: {
                            child.parentNode
                        },
                        set: { newValue in
                            if let index = children.firstIndex(
                                where: { child in
                                    child.parentNode.id == newValue.id
                                }
                            ) {
                                children[index].parentNode = newValue
                            }
                        }
                    )
                )
            }
        }
    }
}
