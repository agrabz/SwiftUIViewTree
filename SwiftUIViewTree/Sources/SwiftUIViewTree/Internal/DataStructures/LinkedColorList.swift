
import SwiftUI

struct LinkedColorList {
    let colors: [Color] = [
        UIConstants.Color.initialNodeBackground,
        .red,
        .yellow,
        .green,
        .orange,
        .pink,
        .mint,
        .indigo,
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
