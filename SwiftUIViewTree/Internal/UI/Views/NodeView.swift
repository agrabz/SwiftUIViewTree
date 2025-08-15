import SwiftUI

@Observable
final class NodeViewModel {
    @ObservationIgnored
    let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
    ]


    @ObservationIgnored
    private var currentIndex = 0

    func backgroundColor() -> Color {
        let backgroundColor = colors.safeGetElement(at: currentIndex % colors.count) ?? colors[0]
        currentIndex += 1
        return backgroundColor
    }
}

struct NodeView: View, Equatable {
    static func == (lhs: NodeView, rhs: NodeView) -> Bool {
        lhs.label == rhs.label &&
        lhs.type == rhs.type
        &&
        lhs.value == rhs.value
    }

    @State private var vm = NodeViewModel()
    let label: String
    let type: String
    var value: String

    var body: some View {
        if label == "isActive" {
            let _ = print("isActive")
            let _ = Self._printChanges()
        }

        if label == "label" {
            let _ = print("label")
            let _ = Self._printChanges()
        }

        if label == "anyTextModifier" {
            let _ = print("anyTextModifier")
            let _ = Self._printChanges()
        }

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
        .background(vm.backgroundColor()) //TODO: this should not be like this but every node should go through a lifecycle based on redraws to spot the differences more easily. maybe color animation should be done here as well not just on the uiState update
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

extension Array {
    func safeGetElement(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
