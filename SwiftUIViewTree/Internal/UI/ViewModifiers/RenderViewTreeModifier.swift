import SwiftUI

struct RenderViewTreeModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            TreeWindowScreen(
                originalContent: content
            )
            .disabled(TreeContainer.shared.isRecomputing)
            .blur(radius: TreeContainer.shared.isRecomputing ? 5.0 : 0.0)

            if TreeContainer.shared.isRecomputing {
                ViewTreeTraversalProgressView()
            }
        }
    }
}
