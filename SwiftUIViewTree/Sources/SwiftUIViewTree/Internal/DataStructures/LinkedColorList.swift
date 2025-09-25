
import SwiftUI

struct LinkedColorList {
    private let colors: [Color] = [
        UIConstants.Color.initialNodeBackground,
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
        .orange.opacity(0.8),
        .pink.opacity(0.8),
        .mint.opacity(0.8),
        .indigo.opacity(0.8)
    ]
    private var currentIndex = 0

    mutating func getNextColor() -> Color {
        currentIndex += 1
        guard let color = colors.safeGetElement(at: currentIndex % colors.count) else {
            return .purple.opacity(0.8)
        }
        return color
    }
}
