import SwiftUI

public extension View {
    //TODO: documentation
    func renderViewTree(
        of originalView: any View,
        isSelf: Bool = true
    ) -> some View {
        let modifiedView = isSelf ? self : originalView

        TreeWindowViewModel.shared.computeViewTree(
            originalView: originalView,
            modifiedView: modifiedView
        )
        return modifier(RenderViewTreeModifier())
    }
}
