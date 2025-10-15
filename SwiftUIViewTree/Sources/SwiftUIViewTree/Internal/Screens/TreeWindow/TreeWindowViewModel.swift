
import SwiftUI

actor SubViewChangeHandler {
    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View,
        uiState: inout TreeWindowUIModel.ComputedUIState,
    ) async {
        let tree = uiState.treeBreakDownOfOriginalContent

        var treeBuilder = TreeBuilder()
        let subviewTree = await treeBuilder.getTreeFrom(
            originalView: originalSubView,
            modifiedView: modifiedSubView
        )

        guard let (changedMatchingSubTree, originalMatchingSubtree) = await TreeBuilder().findMatchingSubtree( //TODO: adjust to include first in its name
            in: tree,
            matching: subviewTree.children.first!.children.first! //TODO: no force cast, this is the path to the "originalView"
        ) else {
            print("couldn't find matching subtree")
            return
        }

        print()
        print("--changedMatchingSubTree", changedMatchingSubTree)
        print("--originalMatchingSubtree", originalMatchingSubtree)
        print()

        for changedNode in await TreeNodeRegistry.shared.allChangedNodes {
            await TreeNodeRegistry.shared.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: changedNode.serialNumber)
        }

        let flattenedChangedMatchingSubTree = await treeBuilder.flatten(changedMatchingSubTree)
        let flattenedOriginalMatchingSubTree = await treeBuilder.flatten(originalMatchingSubtree)
        for (changedNode, originalNode) in zip(
            flattenedChangedMatchingSubTree,
            flattenedOriginalMatchingSubTree
        ) {
            _ = await TreeNode( //initializing a TreeNode comes with the side-effect of registering it to TreeNodeRegistry, which is enough for us to make sure that it'll get the proper details to render a new background color on value change
                type: originalNode.type,
                label: originalNode.label,
                value: originalNode.value,
                serialNumber: changedNode.serialNumber //TODO: is this logical? changedNode.serialNumber sounds to be the one that we try to get rid of?
                //TODO: where is Hello and Yo what?! from the graph
            )
        }

        for changedTreeNode in await TreeNodeRegistry.shared.allChangedNodes {
            print(
                "- changed:",
                await changedTreeNode.serialNumber,
                await changedTreeNode.label,
                await changedTreeNode.type,
                await changedTreeNode.value
            )
            let value = await changedTreeNode.value

            await uiState.treeBreakDownOfOriginalContent[changedTreeNode.serialNumber]?.setValueWithAnimation(to: value)
        }
    }
}

@MainActor
@Observable
final class TreeWindowViewModel {
    /// Unlike usual view models, TreeWindowViewModel is used as a singleton, because its work is triggered before the creation of its view (TreeWindowScreen)
    static var shared: TreeWindowViewModel = .init()
    /// Change this value to simulate longer/shorter computation times
    static let waitTimeInSeconds = 1.0

    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

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

    func computeViewTree(
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
                        computedUIState.treeBreakDownOfOriginalContent[changedValue.serialNumber]?.setValueWithAnimation(
                            to: changedValue.value
                        )
                    }
            }
        }
    }
}
