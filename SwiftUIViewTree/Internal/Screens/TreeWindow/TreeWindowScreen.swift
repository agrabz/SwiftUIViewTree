import SwiftUI

extension EnvironmentValues {
    @Entry var treeCoordinator = TreeCoordinator.shared
}

struct TreeWindowScreen<Content: View>: View {
    @Environment(\.treeCoordinator) private var coordinator: TreeCoordinator
    let originalContent: Content

    var body: some View {
        @Bindable var coordinator = self.coordinator //TODO: Weird: https://www.swiftjectivec.com/getting-bindings-from-environment-swiftui/

        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)
                    .disabled(TreeContainer.shared.isRecomputing)
                    .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

                NavigationStack {
                    switch TreeContainer.shared.uiState {
                        case .computingTree:
                            ViewTreeTraversalProgressView()
                        case .treeComputed(let computedUIState):
                            ZStack {
                                ScrollableZoomableTreeView(
                                    tree: computedUIState.treeBreakDownOfOriginalContent
                                )
                                .disabled(TreeContainer.shared.isRecomputing)
                                .blur(radius: TreeContainer.shared.isRecomputing ? 2.0 : 0.0)

                                if TreeContainer.shared.isRecomputing {
                                    ViewTreeTraversalProgressView()
                                }
                            }
                            .sheet(item: $coordinator.popover) { popover in
                                coordinator.buildPopover(for: popover)
                            }
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
