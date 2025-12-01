import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State private var treeWindowViewModel = TreeWindowViewModel.shared
    @State var showTree: Bool

    let originalContent: Content

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    originalContent
                        .frame(width: showTree ? (proxy.size.width * UIConstants.ScreenRatioOf.originalContent) : proxy.size.width)

                    if showTree {
                        viewFor(uiState: treeWindowViewModel.uiState)
                            .frame(width: proxy.size.width * UIConstants.ScreenRatioOf.viewTree)
                    }
                }
                .transition(.move(edge: .trailing))

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
            Label {
                Text(shouldShowTree ? "Hide Tree" : "Show Tree")
            } icon: {
                Image(systemName: shouldShowTree ? "xmark.circle" : "plus.circle")
            }
            .font(.body)
            .foregroundColor(shouldShowTree ? .red : .green)
        }
        .buttonStyle(.bordered)
        .contentTransition(.symbolEffect)
    }
}
