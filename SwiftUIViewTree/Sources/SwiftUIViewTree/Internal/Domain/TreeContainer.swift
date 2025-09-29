import SwiftUI

@MainActor
@Observable
final class TreeContainer { //TODO: TreeWindowViewModel?
    static var shared: TreeContainer = .init()
    // Change this value to simulate longer/shorter computation times
    static let waitTimeInSeconds = 1.0

    private var treeBuilder = TreeBuilder()
    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

    func computeViewTree(
        maxDepth: Int,
        originalView: any View,
        modifiedView: any View
    ) {
        //TODO: review if this Task can be placed somewhere else, so we might not need the sleep below?
        Task {
            switch uiState {
                case .computingTree:
                    break
                case .treeComputed:
                    withAnimation {
                        isRecomputing = true
                    }
            }

            let newTree = treeBuilder.getTreeFrom(
                originalView: originalView,
                modifiedView: modifiedView,
                maxDepth: maxDepth
            )

            //TODO: without this delay, the view doesn't update properly in some cases (small-medium views only?)
            try? await Task.sleep(for: .seconds(Self.waitTimeInSeconds))

            withAnimation {
                isRecomputing = false
            }

            switch uiState {
                case .computingTree:
                    withAnimation(.easeInOut(duration: 1)) {
                        self.uiState = .treeComputed(
                            .init(
                                treeBreakDownOfOriginalContent: newTree
                            )
                        )
                    }
                case .treeComputed(let computedUIState):
                    for changedValue in TreeNodeRegistry.shared.allChangedNodes {
                        withAnimation {
                            computedUIState
                                .treeBreakDownOfOriginalContent[changedValue.serialNumber]?.value = changedValue.value
                        }
                    }
            }
        }
    }
}
