import SwiftUI

struct StatefulMagnifyGesture: Gesture {
    @Binding var currentZoom: CGFloat
    @Binding var totalZoom: CGFloat
    @Binding var scaleAnchor: UnitPoint?

    var body: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                if scaleAnchor == nil {
                    scaleAnchor = value.startAnchor
                }
                currentZoom = value.magnification - 1
            }
            .onEnded { value in
                totalZoom += currentZoom
                currentZoom = 0
                scaleAnchor = nil
            }
    }
}
