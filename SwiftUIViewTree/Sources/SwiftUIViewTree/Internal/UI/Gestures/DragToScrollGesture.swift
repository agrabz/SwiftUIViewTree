import SwiftUI

struct DragToScrollGesture: Gesture {
    @Binding var offset: CGSize
    let scale: CGFloat

    //TODO: probably these values (2000, 1000) won't be good for all use cases
    /// The maximum horizontal offset allowed at the current scale
    private var horizontalMaxScale: CGFloat {
        2000 * ((scale - floor(scale)) + 1)
    }
    /// The maximum vertical offset allowed at the current scale
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
                    offset = getNewOffset(from: value)
                }
            }
    }
}

private extension DragToScrollGesture {
    func getNewOffset(from value: DragGesture.Value) -> CGSize {
        var newOffset = self.offset
        // Scale is taken as a factor to make the dragging feel more natural when zoomed in, i.e. less sensitive.
        newOffset.width += (value.translation.width / 2) / max(self.scale, 1)
        newOffset.height += (value.translation.height / 2) / max(self.scale, 1)
        return newOffset
    }
}
