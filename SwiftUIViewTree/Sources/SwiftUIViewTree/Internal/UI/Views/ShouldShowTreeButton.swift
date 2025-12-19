
import SwiftUI

struct ShouldShowTreeButton: View {
    @Binding var shouldShowTree: Bool
    var proxy: GeometryProxy

    func xPosition() -> CGFloat {
        if OrientationInfo.isLandscape {
            proxy.size.width - Position.X.landscapeTrailingInset
        } else {
            proxy.size.width - Position.X.portraitTrailingInset
        }
    }

    func yPosition() -> CGFloat {
        if OrientationInfo.isLandscape {
            50
        } else {
            if shouldShowTree { //TODO: maybe this condition is not nice - should check in real projects - maybe even make the position configurable?
                ((proxy.size.height * UIConstants.ScreenRatio.of(.viewTree, on: .vertical)) + Position.Y.Portrait.shouldShowTreeTopInset)
            } else {
                Position.Y.Portrait.shouldNotShowTreeTopInset
            }
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

private extension ShouldShowTreeButton {
    enum Position {
        @MainActor
        enum X {
            static let landscapeTrailingInset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 80 : 120
            static let portraitTrailingInset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 80 : 100
        }

        enum Y {
            @MainActor
            enum Portrait {
                static let shouldShowTreeTopInset: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone ? 30 : 50)
                static let shouldNotShowTreeTopInset: CGFloat = 50
            }
        }
    }
}
