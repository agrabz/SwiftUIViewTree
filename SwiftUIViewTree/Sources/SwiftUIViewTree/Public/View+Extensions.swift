import SwiftUI

public extension View {
    //TODO: documentation
    func renderViewTree(
        of originalView: any View,
        renderMode: RenderMode = .treeGraph
    ) -> some View {
        TreeWindowViewModel.shared.computeViewTree(
            originalView: originalView,
            modifiedView: self
        )
        return viewFor(renderMode)
    }

    //TODO: documentation
    func notifyViewTreeOnChanges(of originalSubView: any View) -> some View {
        TreeWindowViewModel.shared.computeSubViewChanges(
            originalSubView: originalSubView,
            modifiedSubView: self
        )

        return self
    }
}

//TODO: documentation
public enum RenderMode {
    //TODO: documentation
    case none
    //TODO: documentation
    case treeGraph
}

private extension View {
    @ViewBuilder
    func viewFor(_ renderMode: RenderMode) -> some View {
        switch renderMode {
            case .none:
                self
            case .treeGraph:
                modifier(RenderViewTreeModifier())
        }
    }
}
