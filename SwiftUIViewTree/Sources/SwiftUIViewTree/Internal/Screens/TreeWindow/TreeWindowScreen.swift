
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
                    HStack {
                        originalContent
                            .frame(width: showTree ? (proxy.size.width * UIConstants.ScreenRatioOf.originalContent) : proxy.size.width)

                        if showTree {
                            viewFor(uiState: treeWindowViewModel.uiState)
                                .frame(width: proxy.size.width * UIConstants.ScreenRatioOf.viewTree) //TODO: this should always be the 3/4 of the screen even if we use it on a subview
                        }
                    }
                    .transition(.move(edge: .trailing))
                } else {
                    VStack {
                        originalContent
                            .frame(height: showTree ? (proxy.size.height * UIConstants.ScreenRatioOf.originalContent) : proxy.size.height)

                        if showTree {
                            viewFor(uiState: treeWindowViewModel.uiState)
                                .frame(height: proxy.size.height * UIConstants.ScreenRatioOf.viewTree) //TODO: this should always be the 3/4 of the screen even if we use it on a subview
                        }
                    }
                    .transition(.move(edge: .bottom))
                }

                ShouldShowTreeButton(shouldShowTree: self.$showTree)
                    .position(
                        x: proxy.size.width - 50,
                        y: 50
                    )
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    @ViewBuilder
    private func viewFor(uiState: TreeWindowUIModel) -> some View {
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
}
