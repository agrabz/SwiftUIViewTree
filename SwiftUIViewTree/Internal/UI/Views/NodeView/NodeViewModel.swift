import SwiftUI

final class NodeViewModel {
    let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
    ]

    private var currentIndex = 0

    func getBackgroundColor() -> Color {
        let backgroundColor = colors.safeGetElement(at: currentIndex % colors.count) ?? colors[0]
        currentIndex += 1
        return backgroundColor
    }
}
