import SwiftUI

struct NodeView: View {
    @Binding var node: TreeNode

    var body: some View {
        VStack {
            HStack {
                Text(self.node.shortenedLabel)
                    .font(.headline)
                    .fontWeight(.black)

                if self.node.isParent {
                    Image(systemName: self.node.isCollapsed ? "chevron.right" : "chevron.down")
                }
            }

            HStack {
                Text(self.node.shortenedType)
                    .font(.caption)
                    .bold()
                Text(self.node.shortenedValue)
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
        .background(node.backgroundColor)
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
        .overlay(alignment: .topTrailing) {
            if self.node.isCollapsed {
                NodeBadge(count: node.descendantCount)
            }
        }
        .frame(width: 370, height: 200)
        .padding(.all, 8)
    }
}
