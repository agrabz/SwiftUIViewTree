
import SwiftUI

struct ShouldShowTreeButton: View {
    @Binding var shouldShowTree: Bool
    var proxy: GeometryProxy

    func xPosition() -> CGFloat {
        OrientationInfo.isLandscape ? proxy.size.width - 50 : proxy.size.width - 80
    }

    func yPosition() -> CGFloat {
        if OrientationInfo.isLandscape {
            50
        } else {
            (shouldShowTree ? ((proxy.size.height * UIConstants.ScreenRatio.of(.viewTree, on: .vertical)) + 30) : 50) //TODO: maybe this is not nice - should check in real projects - maybe make the position configurable?
        }
    }

    var body: some View {
        Button {
            withAnimation {
                self.shouldShowTree.toggle()
            }
        } label: {
            Label {
                Text(shouldShowTree ? "Hide Tree" : "Show Tree")
            } icon: {
                Image(systemName: shouldShowTree ? "xmark.circle" : "plus.circle")
            }
            .font(.body.bold())
            .foregroundColor(shouldShowTree ? .red : .green)
        }
        .buttonStyle(.bordered)
        .contentTransition(.symbolEffect)
        .position(
            x: xPosition(),
            y: yPosition()
        )
    }
}
