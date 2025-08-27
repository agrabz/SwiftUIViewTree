import SwiftUI

struct NodeView: View {
    @State var viewModel: NodeViewModel
//    @Bindable var node: TreeNode

    private var nodeLabel: String {
        if viewModel.node.label.count > 20 {
            String(viewModel.node.label.prefix(20)) + "..."
        } else {
            viewModel.node.label
        }
    }

    private var nodeType: String {
        if viewModel.node.type.count > 20 {
            String(viewModel.node.type.prefix(20)) + "..."
        } else {
            viewModel.node.type
        }
    }

    private var nodeValue: String {
        if viewModel.node.value.count > 20 {
            String(viewModel.node.value.prefix(20)) + "..."
        } else {
            viewModel.node.value
        }
    }

    private var isCollapsed: Bool {
        viewModel.node.isCollapsed
    }

    var body: some View {
        if viewModel.node.label == "modifiers" && isViewPrintChangesEnabled {
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
                CollapsedNodesStore.shared.toggleCollapse(nodeID: viewModel.node.id)
            }
        }
        .background(
            viewModel.getBackgroundColorAndLogChanges()
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
        lhs.viewModel.node.label == rhs.viewModel.node.label &&
        lhs.viewModel.node.type == rhs.viewModel.node.type &&
        lhs.viewModel.node.value == rhs.viewModel.node.value
    }
}

#Preview {
    NodeView(
        viewModel: .init(
            node: /*.constant(*/
                .init(
                    type: "Type",
                    label: "Label",
                    value: "Value",
                    displayStyle: "DisplayStyle",
                    subjectType: "SubjectType",
                    superclassMirror: "SuperclassMirror",
                    mirrorDescription: "MirrorDescription",
                    childIndex: 0,
                    isParent: true
                )
            //        )
        )
    )
}
