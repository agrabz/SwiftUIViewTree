
import SwiftUI

@Observable
@MainActor
final class OrientationInfo { //TODO: review concurrency errors
    enum Orientation {
        case portrait
        case landscape
    }

    static let shared = OrientationInfo()

    static var isLandscape: Bool {
        shared.orientation == .landscape
    }

    static var isPortrait: Bool {
        !isLandscape
    }

    var orientation: Orientation

    @ObservationIgnored
    private var _observer: NSObjectProtocol?

    init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }

        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default
            .addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] note in
            guard let self, let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            }
            else if device.orientation.isLandscape {
                self.orientation = .landscape
            }
        }
    }

    isolated deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State var showTree: Bool

    let originalContent: Content

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if OrientationInfo.isLandscape {
                    horizontallyAlignedWindow(proxy: proxy)
                } else {
                    verticallyAlignedWindow(proxy: proxy)
                }

                ShouldShowTreeButton(shouldShowTree: self.$showTree)
                    .position(
                        x: ShouldShowTreeButton.xPosition(proxy: proxy),
                        y: ShouldShowTreeButton.yPosition(proxy: proxy)
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
