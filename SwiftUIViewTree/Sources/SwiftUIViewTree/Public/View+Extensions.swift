import SwiftUI

public extension View {
    //TODO: documentation
    func renderViewTree(
        of originalView: any View
    ) -> some View {
        TreeWindowViewModel.shared.computeViewTree(
            originalView: originalView,
            modifiedView: self
        )
        return modifier(RenderViewTreeModifier())
    }

    func notifyViewTree(of originalView: any View) -> some View { //onFirstAppear ViewModifier?
        TreeWindowViewModel.shared.computeViewTree(
            originalView: originalView,
            modifiedView: self
        )

        return self
    }
}
