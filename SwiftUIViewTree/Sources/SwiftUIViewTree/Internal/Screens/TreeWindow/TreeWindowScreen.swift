
import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State var showTree: Bool

    let originalContent: Content

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.window(proxy: proxy)

                ShouldShowTreeButton(
                    shouldShowTree: self.$showTree,
                    proxy: proxy
                )
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }
}

private extension TreeWindowScreen {
    @ViewBuilder
    func viewFor(uiState: TreeWindowUIModel) -> some View {
        switch treeWindowViewModel.uiState {
            case .computingTree:
                ViewTreeTraversalProgressView()
            case .treeComputed(let computedUIState):
                ZStack {
                    ScrollableZoomableTreeView(
                        tree: computedUIState.treeBreakDownOfOriginalContent
                    )

                    if TreeWindowViewModel.shared.isRecomputing {
                        ViewTreeTraversalProgressView()
                    }
                }
        }
    }

    @ViewBuilder
    func window(proxy: GeometryProxy) -> some View {
        if OrientationInfo.isLandscape {
            horizontallyAlignedWindow(proxy: proxy)
        } else {
            verticallyAlignedWindow(proxy: proxy)
        }
    }

    @ViewBuilder
    func horizontallyAlignedWindow(proxy: GeometryProxy) -> some View {
        HStack {
            windowContent(for: .horizontal, proxy: proxy)
        }
        .transition(.move(edge: .trailing))
    }

    @ViewBuilder
    func verticallyAlignedWindow(proxy: GeometryProxy) -> some View {
        VStack {
            windowContent(for: .vertical, proxy: proxy)
        }
        .transition(.move(edge: .bottom))
    }

    @ViewBuilder
    func windowContent(for axis: Axis, proxy: GeometryProxy) -> some View {
        originalContent
            .framePer(
                condition: showTree,
                proxy: proxy,
                factor: UIConstants.ScreenRatio.of(.originalContent, on: axis),
                axis: axis
            )

        if showTree {
            viewFor(uiState: treeWindowViewModel.uiState)
                .framePer(
                    proxy: proxy,
                    factor: UIConstants.ScreenRatio.of(.viewTree, on: axis),
                    axis: axis
                ) //TODO: this should always be the 3/4 of the screen even if we use it on a subview
        }
    }
}

extension View {
    func framePer(condition: Bool = true, proxy: GeometryProxy, factor: CGFloat, axis: Axis) -> some View {
        switch axis {
            case .horizontal:
                frame(width: condition ? (proxy.size.width * factor) : proxy.size.width)
            case .vertical:
                frame(height: condition ? (proxy.size.height * factor) : proxy.size.height)
        }
    }
}
