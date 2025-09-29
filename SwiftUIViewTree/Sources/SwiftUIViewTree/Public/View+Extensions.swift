import SwiftUI

public extension View {
    //TODO: documentation
    //TODO: maxDepth must be greater than 1
    func renderViewTree(of originalView: any View, maxDepth: Int = .max) -> some View {
        TreeWindowViewModel.shared.computeViewTree(
            maxDepth: maxDepth,
            originalView: originalView,
            modifiedView: self
        )
        return modifier(RenderViewTreeModifier())
    }
}
