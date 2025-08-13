import SwiftUI

struct RenderViewTreeModifier: ViewModifier {
    func body(content: Content) -> some View {
        TreeWindowScreen(
            originalContent: content
        )
    }
}
