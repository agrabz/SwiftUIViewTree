
import Combine
import SwiftUI

@MainActor
final class SubviewChangeDetector: ObservableObject {
    static var shared: SubviewChangeDetector = .init()

    var isChangeDetected = PassthroughSubject<Void, Never>()
}


@MainActor
@Observable
final class TreeWindowViewModel {
    /// Unlike usual view models, TreeWindowViewModel is used as a singleton, because its work is triggered before the creation of its view (TreeWindowScreen)
    static var shared: TreeWindowViewModel = .init()
    /// Change this value to simulate longer/shorter computation times
    static let waitTimeInSeconds = 1.0

    private var treeBuilder = TreeBuilder()

    private var originalView: (any View)?
    private var modifiedView: (any View)?

    private var cancellables = Set<AnyCancellable>()

    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

    init() {
        SubviewChangeDetector.shared.isChangeDetected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard
                    let self,
                    let originalView,
                    let modifiedView
                else {
                    return
                }

                self.computeViewTree(
                    originalView: originalView,
                    modifiedView: modifiedView
                )
            }
            .store(in: &cancellables)
    }

    func computeViewTree(
        originalView: any View,
        modifiedView: any View
    ) {
        self.originalView = originalView
        self.modifiedView = modifiedView
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
                modifiedView: modifiedView
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
