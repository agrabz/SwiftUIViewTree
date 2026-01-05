
import SwiftUI

/// This has to be an actor otherwise some weird actor-reentrancy like issue happened when it was straight in the TreeWindowViewModel
actor SubViewChangeHandler {
    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View,
        uiState: inout TreeWindowUIModel.ComputedUIState,
    ) async {
        let subViewTree = await getSubViewTree(
            originalSubView: originalSubView,
            modifiedSubView: modifiedSubView
        )

        let fullTree = uiState.treeBreakDownOfOriginalContent

        guard let subTree = try? await findMatchingSubViewTreeIn(
            fullTree: fullTree,
            subViewTree: subViewTree
        ) else {
            return
        }

        //TODO: would be nice, but probably bigger rework: Add originalSubView and modifiedSubViewTree to the tree

        await registerChangesOfSubtree(subTree)

        await applySubViewChangesToUI(via: &uiState)
    }
}

private extension SubViewChangeHandler {
    enum Error: Swift.Error {
        case notFoundMatchingSubViewTree
    }

    /// Build sub view tree without registering changes (changes would be off due to serialNumber differences)
    func getSubViewTree(
        originalSubView: any View,
        modifiedSubView: any View,
    ) async -> Tree {
        let subviewTree = await TreeBuilder().getTreeFrom(
            originalView: originalSubView,
            modifiedView: modifiedSubView,
            registerChanges: false
        )
        return subviewTree
    }

    func findMatchingSubViewTreeIn(
        fullTree: Tree,
        subViewTree: Tree
    ) async throws -> SubTree {
        guard
            let originalBranchOfSubViewTree = await subViewTree.children.first?.children.first, /// Scope down the search to the originalBranch only.
            let subTree = await SubtreeMatcher.findMatchingSubTree(
                in: fullTree,
                matching: originalBranchOfSubViewTree
            )
        else {
            print()
            print("⚠️ Couldn't find matching subtree, that shouldn't happen!")
            print()
            throw Self.Error.notFoundMatchingSubViewTree
        }

        return subTree
    }

    func registerChangesOfSubtree(_ subTree: SubTree) async {
        let flattenedChangedMatchingSubTree = await TreeFlattener.flatten(
            subTree.changedSubTree
        )
        let flattenedPreviousMatchingSubTree = await TreeFlattener.flatten(
            subTree.previousSubTree
        )

        for (changedNode, previousNode) in zip(
            flattenedChangedMatchingSubTree,
            flattenedPreviousMatchingSubTree
        ) {
            _ = await TreeNode(
                type: previousNode.type,
                label: previousNode.label,
                value: previousNode.value,
                serialNumber: changedNode.serialNumber,
                registerChanges: true
            )
        }
    }

    func applySubViewChangesToUI(via uiState: inout TreeWindowUIModel.ComputedUIState) async {
        for changedTreeNode in await TreeNodeRegistry.shared.allChangedNodes {
            await uiState.treeBreakDownOfOriginalContent[changedTreeNode.serialNumber]?.setValueWithAnimation(
                to: await changedTreeNode.value
            )
        }
    }
}
