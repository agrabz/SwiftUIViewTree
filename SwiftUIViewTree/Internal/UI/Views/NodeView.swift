import SwiftUI

struct NodeView: View {
    let label: String
    let type: String
    let value: String

    static let colors: [Color] = [.gray, .purple, .blue, .green]
    static var colorIndex: Int = 0

    static func nextColor() -> Color {
        colorIndex = (colorIndex + 1) % colors.count
        return colors[colorIndex]
    }

    var body: some View {
        VStack {
            Text(label)
                .font(.headline)
                .fontWeight(.black)

            HStack {
                Text(type)
                    .font(.caption)
                    .bold()
                Text("`\(value)`")
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
        .background(NodeView.nextColor())
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
        .padding(.all, 8)
    }
}
