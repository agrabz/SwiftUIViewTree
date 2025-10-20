
import SwiftUI

actor SubViewChangeHandler {
    func computeSubViewChanges(
        originalSubView: any View,
        modifiedSubView: any View,
        uiState: inout TreeWindowUIModel.ComputedUIState,
    ) async {
        var treeBuilder = await TreeBuilder()
        let subviewTree = await treeBuilder.getTreeFrom(
            originalView: originalSubView,
            modifiedView: modifiedSubView
        )

        let tree = uiState.treeBreakDownOfOriginalContent

        guard let (changed: changedMatchingSubTree, original: originalMatchingSubtree) = await SubtreeMatcher.findMatchingSubtree( //TODO: adjust to include first in its name
            in: tree,
            matching: subviewTree.children.first!.children.first! //TODO: no force cast, this is the path to the "originalView"
        ) else {
            print("couldn't find matching subtree")
            return
        }

        for changedNode in await TreeNodeRegistry.shared.allChangedNodes {
            await TreeNodeRegistry.shared.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: changedNode.serialNumber)
        }

        let flattenedChangedMatchingSubTree = await treeBuilder.flatten(
            changedMatchingSubTree
        )
        let flattenedOriginalMatchingSubTree = await treeBuilder.flatten(
            originalMatchingSubtree
        )

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
            await uiState.treeBreakDownOfOriginalContent[changedTreeNode.serialNumber]?.setValueWithAnimation(
                to: await changedTreeNode.value
            )
        }
    }
}
