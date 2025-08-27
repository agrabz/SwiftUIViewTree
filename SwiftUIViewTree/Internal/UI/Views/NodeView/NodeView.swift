import SwiftUI

struct NodeView: View {
    @State var viewModel = NodeViewModel()
    @Bindable var node: TreeNode

    private var nodeLabel: String {
        if node.label.count > 20 {
            String(node.label.prefix(20)) + "..."
        } else {
            node.label
        }
    }

    private var nodeType: String {
        if node.type.count > 20 {
            String(node.type.prefix(20)) + "..."
        } else {
            node.type
        }
    }

    private var nodeValue: String {
        if node.value.count > 20 {
            String(node.value.prefix(20)) + "..."
        } else {
            node.value
        }
    }

    private var isCollapsed: Bool {
        CollapsedNodesStore.shared.isCollapsed(nodeID: node.id)
    }

    var body: some View {
        if node.label == "modifiers" && isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("NodeView")
            let _ = Self._printChanges()
            let _ = print("----- NodeView DONE -----") //As this view is the last in the hierarchy, this helps to see when all changes have been printed
            let _ = print()
            let _ = print()
            let _ = print()
        }

        VStack {
            HStack {
                Text(self.nodeLabel)
                    .font(.headline)
                    .fontWeight(.black)

                Image(systemName: self.isCollapsed ? "chevron.right" : "chevron.down")
            }

            HStack {
                Text(self.nodeType)
                    .font(.caption)
                    .bold()
                Text(self.nodeValue)
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .italic()
            }
            .padding(.all, 8)
            .background(.white)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 0.5)
            }
        }
        .foregroundStyle(.black)
        .padding(.all, 8)
        //TODO: use onChange(of:) instead?
        .onLongPressGesture {
            withAnimation {
                CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)
            }
        }
        .background(
            viewModel.getBackgroundColorAndLogChanges(node: node)
        )
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
        .frame(width: 370, height: 200)
        .padding(.all, 8)

    }
}

@Observable
final class CollapsedNodesStore {
    static let shared = CollapsedNodesStore()
    private init() {}

    var collapsedNodeIDs: Set<String> = []

    func isCollapsed(nodeID: String) -> Bool {
        collapsedNodeIDs.contains(nodeID)
    }

    func toggleCollapse(nodeID: String) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
    }

    func clear() {
        collapsedNodeIDs.removeAll()
    }
}


extension NodeView: Equatable {
    static func == (lhs: NodeView, rhs: NodeView) -> Bool {
        lhs.node.label == rhs.node.label &&
        lhs.node.type == rhs.node.type &&
        lhs.node.value == rhs.node.value
    }
}

//#Preview {
//    NodeView(
//        viewModel: .init(
//            node: /*.constant(*/
//                .init(
//                    type: "Type",
//                    label: "Label",
//                    value: "Value",
//                    displayStyle: "DisplayStyle",
//                    subjectType: "SubjectType",
//                    superclassMirror: "SuperclassMirror",
//                    mirrorDescription: "MirrorDescription",
//                    childIndex: 0,
//                    isParent: true
//                )
//            //        )
//        )
//    )
//}
