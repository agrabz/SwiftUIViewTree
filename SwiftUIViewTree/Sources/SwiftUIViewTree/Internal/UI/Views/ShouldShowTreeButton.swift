
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
            .font(isPhone ? .headline : .title2)
            .fontWeight(.bold)
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
            static let landscapeTrailingInset: CGFloat = isPhone ? 50 : 120
            static let portraitTrailingInset: CGFloat = isPhone ? 80 : 100
        }

        enum Y {
            @MainActor
            enum Portrait {
                static let shouldShowTreeTopInset: CGFloat = (isPhone ? 30 : 50)
                static let shouldNotShowTreeTopInset: CGFloat = 50
            }
        }
    }
}
