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
                withAnimation {
                    currentZoom = getClampedNewCurrentZoom(from: value)
                }
            }
            .onEnded { value in
                withAnimation {
                    totalZoom = getClampedTotalZoom()
                    currentZoom = Self.idleZoom
                }
            }
    }
}

private extension StatefulMagnifyGesture {
    func getClampedNewCurrentZoom(from value: MagnifyGesture.Value) -> CGFloat {
        let newlyProposedZoom = value.magnification - 1
        let newTotalZoom = totalZoom + newlyProposedZoom

        let clampedNewCurrentZoom =
        if newTotalZoom < Self.minZoom {
            Self.minZoom - totalZoom
        } else if newTotalZoom > Self.maxZoom {
            Self.maxZoom - totalZoom
        } else {
            newlyProposedZoom
        }

        return clampedNewCurrentZoom
    }

    func getClampedTotalZoom() -> CGFloat {
        min(max(totalZoom + currentZoom, Self.minZoom), Self.maxZoom)
    }
}
