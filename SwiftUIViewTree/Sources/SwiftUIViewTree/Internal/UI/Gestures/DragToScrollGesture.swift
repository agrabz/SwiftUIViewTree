import SwiftUI

struct DragToScrollGesture: Gesture {
    @Binding var offset: CGSize
    let scale: CGFloat

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
    //TODO: there used to be some clamping here but it was fragile. got deleted in commit: fae1d7469c45fbfc4ebb7eff808abee453b00e5f
    func getNewOffset(from value: DragGesture.Value) -> CGSize {
        var newOffset = self.offset
        // Scale is taken as a factor to make the dragging feel more natural when zoomed in, i.e. less sensitive.
        newOffset.width += (value.translation.width / 2) / max(self.scale, 1)
        newOffset.height += (value.translation.height / 2) / max(self.scale, 1)
        return newOffset
    }
}
