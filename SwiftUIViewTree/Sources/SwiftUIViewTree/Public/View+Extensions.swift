import SwiftUI

public extension View {
    /// Renders the view tree of the SwiftUI view it is used on. The view tree is essentially the programmatic structure of the view.
    ///
    /// It is suggested to use this function on a full-screen view for the best UX.
    ///
    /// On value changes the specific node's background gets changed, plus the old and the new values gets printed to the console.
    /// The canvas of the graph can be scrolled and zoomed (both pinch and double tap).
    /// Tapping on any node will display its details - might be useful if you don't want to zoom in, but want to make sure that you're checking the node that interests you.
    /// Double tapping any parent node will collapse/ re-expand its children. A collapsed node color is always grey and a badge is indicating the total number of its descendants that got collapsed. A collapsed node is still being tracked so its changes will still result in console prints.
    ///
    /// - Parameters:
    ///   - originalView: The view whose view tree you would like to see. Pass in `self`.
    ///   - renderMode: Indicates how you want to see the view tree. Default value is `.treeGraph(showTreeInitially: true)`.
    ///   - settings: Indicates what features you want to turn on/off that are by default disabled/enabled.
    ///
    /// - See Also: `RenderMode`
    /// - See Also: `SwiftUIViewTreeSetting`
    /// - See Also: `notifyViewTreeOnChanges`
    /// - See Also: ``https://github.com/agrabz/SwiftUIViewTree``
    func renderViewTree(
        of originalView: any View,
        renderMode: RenderMode = .treeGraph(showTreeInitially: true),
        settings: [SwiftUIViewTreeSetting] = []
    ) -> some View {
        SwiftUIViewTreeConfiguration.shared.applySettings(settings)

        TreeWindowViewModel.shared.computeViewTree(
            originalView: originalView,
            modifiedView: self
        )

        return viewFor(renderMode)
    }

    /// Connects the subview with the view tree. It is important if you want to track the changes of your subview as well.
    ///
    /// Due to the nature of SwiftUI, a subview change doesn't automatically result in its parent's redrawal. Therefore the two have to be connected via this function.
    /// Note that right now a subview only shows its "original" branch, not its "modified" branch.
    /// Showing the "modified" branch on the tree is up on the roadmap.
    ///
    /// - See Also: `renderViewTree(of:renderMode:)`
    func notifyViewTreeOnChanges(of originalSubView: any View) -> some View {
        TreeWindowViewModel.shared.computeSubViewChanges(
            originalSubView: originalSubView,
            modifiedSubView: self
        )

        return self
    }
}

/// The mode to render the view tree.
///
/// - See Also: `renderViewTree(of:renderMode:)`
public enum RenderMode {
    /// Indicates that you don't want to see the view tree at all.
    /// Might be useful if you only want to use the diff printing feature.
    case never
    /// Indicates that you want to see the view tree as a tree graph. Its parameter (`showTreeInitially`) means whether you want to see the view tree right after the original view got loaded.
    ///
    /// Passing in `false` will show the "Show Tree" button floating over your original view. Tapping it will show the view tree as a graph, while the button will transform into "Hide Tree".
    /// Passing in `true` will show the tree graph next to your original view, together with the "Hide Tree" button. Tapping it will hide the tree graph, while the button will transform into "Show Tree".
    case treeGraph(showTreeInitially: Bool)
}

public enum SwiftUIViewTreeSetting {
    /// SwiftUI uses reference types under the hood sometimes for things like `LocalizedTextStorage`.
    /// The `Mirror` provided APIs include the memory addresses of these types.
    /// These may change for less obvious reasons and keeping track of them is most probably not super useful, nor helpful, therefore by default this is turned off.
    case enableMemoryAddressDiffing
}

private extension View {
    @ViewBuilder
    func viewFor(_ renderMode: RenderMode) -> some View {
        switch renderMode {
            case .never:
                self
            case .treeGraph(let showTree):
                modifier(
                    RenderViewTreeModifier(
                        showTree: showTree
                    )
                )
        }
    }
}
