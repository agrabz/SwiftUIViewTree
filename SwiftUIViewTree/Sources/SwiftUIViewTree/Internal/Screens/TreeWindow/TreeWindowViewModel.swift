
import Combine
import SwiftUI

//@MainActor
//final class SubviewChangeDetector: ObservableObject {
//    static var shared: SubviewChangeDetector = .init()
//
//    var isChangeDetected = PassthroughSubject<Void, Never>()
//}


@MainActor
@Observable
final class TreeWindowViewModel {
    /// Unlike usual view models, TreeWindowViewModel is used as a singleton, because its work is triggered before the creation of its view (TreeWindowScreen)
    static var shared: TreeWindowViewModel = .init()
    /// Change this value to simulate longer/shorter computation times
    static let waitTimeInSeconds = 1.0

//    private var originalView: (any View)?
//    private var modifiedView: (any View)?

    private var cancellables = Set<AnyCancellable>()

    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

//    init() {
//        SubviewChangeDetector.shared.isChangeDetected
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in
//                guard
//                    let self,
//                    let originalView,
//                    let modifiedView
//                else {
//                    return
//                }
//
//                self.computeViewTree(
//                    originalView: originalView,
//                    modifiedView: modifiedView
//                )
//            }
//            .store(in: &cancellables)
//    }

    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View
    ) {
        ///get full viewtree
        guard case .treeComputed(let computedUIState) = uiState else {
            return
        }

        let tree = computedUIState.treeBreakDownOfOriginalContent

        ///get viewtree of the changed subview --> this comes with the side effect of TreeNodeRegistry registrations that won't be accurate as the subview's children cannot have the same serial numbers as the original view got - this is handled later below
        var treeBuilder = TreeBuilder()
        let subviewTree = treeBuilder.getTreeFrom(
            originalView: originalSubView,
            modifiedView: modifiedSubView
        )

        ///find FIRST subviewtree in full viewtree - later I should make it better to find the exact one
        ///merge the two trees
        guard let (changedMatchingSubTree, originalMatchingSubtree) = TreeBuilder().findMatchingSubtree( //TODO: adjust to include first in its name
            in: tree,
            matching: subviewTree.children.first!.children.first! //TODO: no force cast
        ) else {
            print("couldn't find matching subtree")
            return
        }
//        merge(
//            fullTree: tree,
//            subViewTree: subviewTree
//        )

        print()
        print("--changedMatchingSubTree", changedMatchingSubTree)
        print("--originalMatchingSubtree", originalMatchingSubtree)
        print()

        ///apply changes
        guard case .treeComputed(let computedUIState) = uiState else {
            return
        }

        /// remove semi-correct change registrations and replace them with correct registrations
        let allChangedNodes = TreeNodeRegistry.shared.allChangedNodes
        for changedNode in allChangedNodes {
            TreeNodeRegistry.shared.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: changedNode.serialNumber)
        }

        let flattenedChangedMatchingSubTree = treeBuilder.flatten(changedMatchingSubTree)
        let flattenedOriginalMatchingSubTree = treeBuilder.flatten(originalMatchingSubtree)
        for (changedNode, originalNode) in zip(
            flattenedChangedMatchingSubTree,
            flattenedOriginalMatchingSubTree
        ) {
            _ = TreeNode( //initializing a TreeNode comes with the side-effect of registering it to TreeNodeRegistry, which is enough for us to make sure that it'll get the proper details to render a new background color on value change
                type: originalNode.type,
                label: originalNode.label,
                value: originalNode.value,
                serialNumber: changedNode.serialNumber //TODO: is this logical? changedNode.serialNumber sounds to be the one that we try to get rid of?
                //TODO: where is Hello and Yo what?! from the graph
            )
        }

        for changedTreeNode in TreeNodeRegistry.shared.allChangedNodes {
            print("- changed:", changedTreeNode.serialNumber, changedTreeNode.label, changedTreeNode.type, changedTreeNode.value)
            withAnimation {
                computedUIState
                    .treeBreakDownOfOriginalContent[changedTreeNode.serialNumber]?.value = changedTreeNode.value
            }
        }
    }

    func computeViewTree(
        originalView: any View,
        modifiedView: any View
    ) {
//        self.originalView = originalView
//        self.modifiedView = modifiedView
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

            var treeBuilder = TreeBuilder()
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
