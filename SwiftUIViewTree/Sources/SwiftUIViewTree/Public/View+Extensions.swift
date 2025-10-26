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

    //TODO: documentation
    func notifyViewTreeOnChanges(of originalSubView: any View) -> some View {
        if !IsFirst.shared.getValue() {
            TreeWindowViewModel.shared.computeSubViewChanges(
                originalSubView: originalSubView,
                modifiedSubView: self
            )
        }

        return self
    }
}
