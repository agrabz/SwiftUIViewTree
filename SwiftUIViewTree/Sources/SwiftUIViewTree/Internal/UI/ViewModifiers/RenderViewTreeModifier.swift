import SwiftUI

struct RenderViewTreeModifier: ViewModifier {
    func body(content: Content) -> some View {
            TreeWindowScreen(
                originalContent: content
            )
    }
}

struct NotifyViewTreeModifier: ViewModifier {
    @State private var isFirst = true
    var originalSubView: any View
    var modifiedSubView: any View

    func body(content: Content) -> some View {
        if isFirst { // first time means that .renderViewTree(of:) is still working
            content
                .onAppear {
                    isFirst.toggle()
                }
        } else {
            content
                .onAppear {
                    TreeWindowViewModel.shared
                        .computeSubViewChanges(
                            originalSubView: self.originalSubView,
                            modifiedSubView: self.modifiedSubView
                        )
                }
        }
    }
}
