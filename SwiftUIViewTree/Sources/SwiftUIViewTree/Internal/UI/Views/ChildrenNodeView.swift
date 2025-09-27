import SwiftUI

struct ChildrenNodeView: View, @MainActor Equatable {
    static func == (lhs: ChildrenNodeView, rhs: ChildrenNodeView) -> Bool {
        lhs.children.map(\.parentNode.value) == rhs.children.map(\.parentNode.value)
    }

    @Binding var children: [Tree]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(children, id: \.parentNode.id) { child in
                if child.parentNode.label == "modifiers" && isViewPrintChangesEnabled {
                    let _ = print()
                    let _ = print("ChildrenNodeView")
                    let _ = Self._printChanges()
                    let _ = print()
                }

                TreeView(tree: .init(get: {
                    child
                }, set: { newValue in
                    if let index = children.firstIndex(where: { child in
                        child.parentNode.id == newValue.parentNode.id
                    }) {
                        children[index] = newValue
                    }
                }))
                .equatable()
            }
        }
    }
}
