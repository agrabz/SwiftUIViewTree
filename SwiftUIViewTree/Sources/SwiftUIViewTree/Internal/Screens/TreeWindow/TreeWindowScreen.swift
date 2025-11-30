import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State private var shouldShowTree = true

    let originalContent: Content

    var body: some View {
        ZStack(alignment: .top) {
            if shouldShowTree {
                HStack {
                    originalContent
                        .frame(width: UIScreen.main.bounds.width * UIConstants.ScreenRatioOf.originalContent)

                    viewFor(uiState: treeWindowViewModel.uiState)
                        .frame(width: UIScreen.main.bounds.width * UIConstants.ScreenRatioOf.viewTree)
                }
            } else {
                originalContent
            }

            ShouldShowTreeButton(shouldShowTree: self.$shouldShowTree)
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
