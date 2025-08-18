import SwiftUI

struct NodeView: View {
    @State private var viewModel = NodeViewModel()
    @Binding var node: TreeNode

    var body: some View {
        VStack {
            Text(node.label)
                .font(.headline)
                .fontWeight(.black)

            HStack {
                Text(node.type)
                    .font(.caption)
                    .bold()
                Text("`\(node.value)`")
                    .font(.caption)
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
        .background(viewModel.getBackgroundColor())
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
        .padding(.all, 8)
    }
}

extension NodeView: Equatable {
    static func == (lhs: NodeView, rhs: NodeView) -> Bool {
        lhs.node.label == rhs.node.label &&
        lhs.node.type == rhs.node.type &&
        lhs.node.value == rhs.node.value
    }
}
