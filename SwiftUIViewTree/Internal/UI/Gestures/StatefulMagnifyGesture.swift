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

struct DragyGesture: Gesture {
    @Binding var offset: CGSize
    //slow down dragging with the amount of current scale
    var scale: CGFloat

    //probably these values (2000, 1000) won't be good for all use cases
    private var horizontalMaxScale: CGFloat {
        2000 * ((scale - floor(scale)) + 1)
    }
    private var verticalMaxScale: CGFloat {
        1000 * ((scale - floor(scale)) + 1)
    }

    var body: some Gesture {
        DragGesture()
            .onChanged { value in
                var newOffset = offset
                newOffset.width += (value.translation.width / 2) / max(scale, 1)
                newOffset.height += (value.translation.height / 2) / max(scale, 1)

                withAnimation {
                    offset = newOffset
                }
            }
            .onEnded { value in
                var newOffset = offset
                newOffset.width += (value.translation.width / 2) / max(scale, 1)
                newOffset.height += (value.translation.height / 2) / max(scale, 1)

                newOffset.width = min(max(newOffset.width, -horizontalMaxScale), horizontalMaxScale)
                newOffset.height = min(max(newOffset.height, -verticalMaxScale), verticalMaxScale)

                withAnimation {
                    offset = newOffset
                }
            }
    }
}
