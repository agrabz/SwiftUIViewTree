import SwiftUI

struct DragToScrollGesture: Gesture {
    @Binding var offset: CGSize
    //slow down dragging with the amount of current scale
    let scale: CGFloat

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
                withAnimation {
                    offset = getNewOffset(from: value)
                }
            }
            .onEnded { value in
                withAnimation {
                    offset = getClampedNewOffset(from: value)
                }
            }
    }
}

private extension DragToScrollGesture {
    func getNewOffset(from value: DragGesture.Value) -> CGSize {
        var newOffset = self.offset
        newOffset.width += (value.translation.width / 2) / max(self.scale, 1)
        newOffset.height += (value.translation.height / 2) / max(self.scale, 1)
        return newOffset
    }

    func getClampedNewOffset(from value: DragGesture.Value) -> CGSize {
        let newOffset = getNewOffset(from: value)
        let clampedNewOffset = clampNewOffset(newOffset)
        return clampedNewOffset
    }

    func clampNewOffset(_ newOffset: CGSize) -> CGSize {
        var newOffset = newOffset
        newOffset.width = min(max(newOffset.width, -horizontalMaxScale), horizontalMaxScale)
        newOffset.height = min(max(newOffset.height, -verticalMaxScale), verticalMaxScale)
        return newOffset
    }
}
