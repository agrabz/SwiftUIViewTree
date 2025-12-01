import SwiftUI

struct RenderViewTreeModifier: ViewModifier {
    let showTree: Bool

    func body(content: Content) -> some View {
            TreeWindowScreen(
                showTree: showTree,
                originalContent: content
            )
    }
}
