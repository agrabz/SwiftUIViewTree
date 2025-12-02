
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

        //TODO: would be nice, but probably bigger rework: Add modifiedSubViewTree to the tree. `subViewTree` already contains it (along with the original). Hard thing is to map State to Binding

        if let updatedTree = await SubtreeMatcher.replaceMatchingSubTree(
            with: subViewTree,
            matching: await subViewTree.children.first!.children.first!,
            in: fullTree
        ) {
            print("updatedTree", updatedTree)
            uiState.treeBreakDownOfOriginalContent = updatedTree
        }

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
        var treeBuilder = await TreeBuilder()
        let subviewTree = await treeBuilder.getTreeFrom(
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
        let flattenedOriginalMatchingSubTree = await TreeFlattener.flatten(
            subTree.originalSubTree
        )

        for (changedNode, originalNode) in zip(
            flattenedChangedMatchingSubTree,
            flattenedOriginalMatchingSubTree
        ) {
            _ = await TreeNode(
                type: originalNode.type,
                label: originalNode.label,
                value: originalNode.value,
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
