import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State private var shouldShowTree = true

    let originalContent: Content

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                // Main content uses the available space, but button positioning is based on proxy.size
                VStack {
                    if shouldShowTree {
                        HStack {
                            originalContent
                                .frame(width: proxy.size.width * UIConstants.ScreenRatioOf.originalContent)

                            viewFor(uiState: treeWindowViewModel.uiState)
                                .frame(width: proxy.size.width * UIConstants.ScreenRatioOf.viewTree)
                        }
                    } else {
                        originalContent
                    }
                }
                // Absolute positioning for a stable location relative to the screen/container
                ShouldShowTreeButton(shouldShowTree: self.$shouldShowTree)
                    .position(
                        x: proxy.size.width - 50, // adjust as needed
                        y: 50 // adjust as needed
                    )
            }
//            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
//            .contentShape(Rectangle()) // ensures ZStack fills hit-testing
        }
    }

    @ViewBuilder
    private func viewFor(uiState: TreeWindowUIModel) -> some View {
        switch treeWindowViewModel.uiState {
            case .computingTree:
                ViewTreeTraversalProgressView()
                    .onDisappear {
                        if isPerformanceLoggingEnabled {
                            print("ViewTreeTraversalProgressView disappeared at \(Date())")
                        }
                    }
            case .treeComputed(let computedUIState):
                if isViewPrintChangesEnabled {
                    let _ = print()
                    let _ = print("ChildrenNodeView")
                    let _ = Self._printChanges()
                    let _ = print()
                }

                ZStack {
                    ScrollableZoomableTreeView(
                        tree: computedUIState.treeBreakDownOfOriginalContent
                    )
                    .disabled(TreeWindowViewModel.shared.isRecomputing)
                    .blur(radius: TreeWindowViewModel.shared.isRecomputing ? 2.0 : 0.0)

                    if TreeWindowViewModel.shared.isRecomputing {
                        ViewTreeTraversalProgressView()
                    }
                }
                .onAppear {
                    if isPerformanceLoggingEnabled {
                        print("ScrollableZoomableTreeView appeared from TreeWindowScreen at \(Date())")
                    }
                }
        }
    }
}
struct ShouldShowTreeButton: View {
    @Binding var shouldShowTree: Bool

    var body: some View {
        Button {
            withAnimation {
                self.shouldShowTree.toggle()
            }
        } label: {
            Image(systemName: shouldShowTree ? "xmark.circle" : "plus.circle")
                .font(.largeTitle)
                .foregroundColor(shouldShowTree ? .red : .green)
        }
    }
}
