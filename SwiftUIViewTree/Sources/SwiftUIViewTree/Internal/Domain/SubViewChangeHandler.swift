
import SwiftUI

/// This has to be an actor otherwise some weird actor-reentrancy like issue happened when it was straight in the TreeWindowViewModel
actor SubViewChangeHandler {
    //TODO: this func is too big, docs are added for now but at least some private funcs would be nice
    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View,
        uiState: inout TreeWindowUIModel.ComputedUIState,
    ) async {
        /// Build sub view tree without registering changes (changes would be off due to serialNumber differences)
        var treeBuilder = await TreeBuilder()
        let subviewTree = await treeBuilder.getTreeFrom(
            originalView: originalSubView,
            modifiedView: modifiedSubView,
            registerChanges: false
        )

        let fullTree = uiState.treeBreakDownOfOriginalContent

        /// Find matching sub tree
        //Right now we cannot properly differentiate between subviews that are the same, so we always return the first match. Later it should be adjusted with a @State UUID approach like .notifyViewTreeOnChanges(of: self, id: $id)
        guard
            let originalSubViewAsTree = await subviewTree.children.first?.children.first,
            let (changed: changedFirstMatchingSubTree, original: originalMatchingSubtree) = await SubtreeMatcher.findMatchingSubtree(
                in: fullTree,
                matching: originalSubViewAsTree
            )
        else {
            print()
            print("⚠️ Couldn't find matching subtree, that shouldn't happen!")
            print()
            return
        }

        //TODO: would be nice, but probably bigger rework: Add originalSubView and modifiedSubViewTree to the tree

        /// Register real changes
        let flattenedChangedMatchingSubTree = await TreeFlattener.flatten(
            changedFirstMatchingSubTree
        )
        let flattenedOriginalMatchingSubTree = await TreeFlattener.flatten(
            originalMatchingSubtree
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

        /// Apply real changes
        for changedTreeNode in await TreeNodeRegistry.shared.allChangedNodes {
            await uiState.treeBreakDownOfOriginalContent[changedTreeNode.serialNumber]?.setValueWithAnimation(
                to: await changedTreeNode.value
            )
        }
    }
}
