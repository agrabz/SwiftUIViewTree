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

    func notifyViewTreeOnRerender(of originalSubView: any View) -> some View {
        if !IsFirst.shared.isFirst {
            TreeWindowViewModel.shared
                .computeSubViewChanges(
                    originalSubView: originalSubView,
                    modifiedSubView: self
                )

            return self
        } else {
            IsFirst.shared.isFirst = false
            return self
        }
    }
}

@MainActor
final class IsFirst {
    static let shared = IsFirst()
    private init() {}
    var isFirst = true
}
