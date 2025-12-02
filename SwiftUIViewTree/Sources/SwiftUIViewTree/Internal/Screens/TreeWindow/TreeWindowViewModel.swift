
import Combine
import SwiftUI

@MainActor
@Observable
final class TreeWindowViewModel {
    /// Unlike usual view models, TreeWindowViewModel is used as a singleton, because its work is triggered before the creation of its view (TreeWindowScreen)
//    static var shared: TreeWindowViewModel = .init()

    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        AAA.shared.$newTree
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTree in
                guard let newTree, let self else { return }

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
                            computedUIState.treeBreakDownOfOriginalContent[changedValue.serialNumber]?.setValueWithAnimation(
                                to: changedValue.value
                            )
                        }
                }

            }
            .store(in: &cancellables)
    }

    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View
    ) {
        guard case .treeComputed(var computedUIState) = uiState else {
            return
        }

        Task {
            await SubViewChangeHandler().computeSubViewChanges(
                originalSubView: originalSubView,
                modifiedSubView: modifiedSubView,
                uiState: &computedUIState
            )
        }
    }


}

@MainActor
final class AAA: ObservableObject {
    static var shared = AAA()

    @Published var newTree: Tree? = nil

    init() {}

    func computeViewTree(
        originalView: any View,
        modifiedView: any View
    ) {
//        switch uiState {
//            case .computingTree:
//                break
//            case .treeComputed:
//                withAnimation {
//                    isRecomputing = true
//                }
//        }

        Task {
            var treeBuilder = TreeBuilder()
            let newTree = treeBuilder.getTreeFrom(
                originalView: originalView,
                modifiedView: modifiedView,
                registerChanges: true
            )
            self.newTree = newTree

//            withAnimation {
//                isRecomputing = false
//            }

//            switch uiState {
//                case .computingTree:
//                    withAnimation(.easeInOut(duration: 1)) {
//                        self.uiState = .treeComputed(
//                            .init(
//                                treeBreakDownOfOriginalContent: newTree
//                            )
//                        )
//                    }
//                case .treeComputed(let computedUIState):
//                    for changedValue in TreeNodeRegistry.shared.allChangedNodes {
//                        computedUIState.treeBreakDownOfOriginalContent[changedValue.serialNumber]?.setValueWithAnimation(
//                            to: changedValue.value
//                        )
//                    }
//            }
        }
    }
}
