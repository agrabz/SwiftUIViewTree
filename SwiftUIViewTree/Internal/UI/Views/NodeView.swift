import SwiftUI

struct NodeView: View {
    let label: String
    let type: String
    let value: String

    static let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .blue.opacity(0.8),
        .green.opacity(0.8),
    ]
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
        .background(Color.getRandomBrightColor()) //TODO: this should not be like this but every node should go through a lifecycle based on redraws to spot the differences more easily. maybe color animation should be done here as well not just on the uiState update
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
        .padding(.all, 8)
    }
}

private extension Color {
    static func getRandomBrightColor() -> Color {
        Color(
            uiColor: UIColor(
                hue: .random(in: 0...1),
                saturation: .random(in: 0.6...1),
                brightness: .random(in: 0.8...1),
                alpha: 1
            )
        )
    }
}
