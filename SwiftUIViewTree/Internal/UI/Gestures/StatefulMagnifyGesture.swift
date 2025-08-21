import SwiftUI

struct StatefulMagnifyGesture: Gesture {
    @Binding var currentZoom: CGFloat
    @Binding var totalZoom: CGFloat

    var body: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                currentZoom = value.magnification - 1
            }
            .onEnded { value in
                totalZoom += currentZoom
                currentZoom = 0
            }
    }
}

struct DragyGesture: Gesture {
    @Binding var offset: CGSize

    var body: some Gesture {
        DragGesture()
            .onChanged { value in
                var newOffset = offset
                newOffset.width += value.translation.width / 2
                newOffset.height += value.translation.height / 2
                withAnimation {
                    offset = newOffset
                }
            }
            .onEnded { value in
                var newOffset = offset
                newOffset.width += value.translation.width / 2
                newOffset.height += value.translation.height / 2
                withAnimation {
                    offset = newOffset
                }
            }
    }
}
