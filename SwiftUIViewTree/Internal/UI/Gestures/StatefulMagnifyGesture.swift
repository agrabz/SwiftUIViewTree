import SwiftUI

struct StatefulMagnifyGesture: Gesture {
    static let idleZoom: CGFloat = 0.0
    static let minZoom: CGFloat = 0.1
    static let maxZoom: CGFloat = 1

    @Binding var currentZoom: CGFloat
    @Binding var totalZoom: CGFloat

    var body: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                withAnimation { //TODO: current zoom has to be clamped as well
                    currentZoom = value.magnification - 1
                }
            }
            .onEnded { value in
                withAnimation {
                    totalZoom = min(max(totalZoom + currentZoom, Self.minZoom), Self.maxZoom)
                    currentZoom = Self.idleZoom
                }
            }
    }
}
