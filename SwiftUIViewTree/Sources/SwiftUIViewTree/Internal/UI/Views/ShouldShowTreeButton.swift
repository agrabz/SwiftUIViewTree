
import SwiftUI

struct ShouldShowTreeButton: View {
    @Binding var shouldShowTree: Bool

    static func xPosition(proxy: GeometryProxy) -> CGFloat {
        OrientationInfo.isLandscape ? proxy.size.width - 50 : proxy.size.width - 80
    }

    static func yPosition(proxy: GeometryProxy) -> CGFloat {
        OrientationInfo.isLandscape ? 50 : ((proxy.size.height * UIConstants.ScreenRatio.of(.viewTree, on: .vertical)) + 30)
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
    }
}
