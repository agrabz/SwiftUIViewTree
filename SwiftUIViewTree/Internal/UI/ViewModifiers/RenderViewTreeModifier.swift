import SwiftUI

struct RenderViewTreeModifier: ViewModifier {
    @State var treeContainer: TreeContainer

    func body(content: Content) -> some View {
        TreeWindowScreen(
            originalContent: content
        )
    }
}
