
import SwiftUI

@MainActor
struct TreeBuilder { //TODO: test
    private let validationList: [any TreeNodeValidatorProtocol] = [
        LocationLabelTreeNodeValidator(),
        AtomicBoxTypeTreeNodeValidator(),
        AtomicBufferTypeTreeNodeValidator(),
    ]
    private var nodeSerialNumberCounter = NodeSerialNumberCounter()

    func getTreeFrom(
        originalView: any View,
        modifiedView: any View,
        registerChanges: Bool
    ) async -> Tree {
        await nodeSerialNumberCounter.reset()

        let newTree = Tree(
            node: .rootNode
        )

        let originalViewRootTree = await getRootTree(
            from: originalView,
            as: .originalView,
            registerChanges: registerChanges
        )
        newTree.children.append(originalViewRootTree)

        let modifiedViewRootTree = await getRootTree(
            from: modifiedView,
            as: .modifiedView,
            registerChanges: registerChanges
        )
        newTree.children.append(modifiedViewRootTree)

        return newTree
    }
}

private extension TreeBuilder {
    func getChildrenTrees(
        mirror: Mirror,
        sourceView: any View,
        registerChanges: Bool
    ) async -> [Tree] {
        await withTaskGroup { childrenTreeGetterTaskGroup in
            for child in mirror.children {
                childrenTreeGetterTaskGroup.addTask { @MainActor @Sendable in
                    await self.convertToTreesRecursively(
                        mirrorChild: child,
                        registerChanges: registerChanges,
                        sourceView: sourceView
                    )
                }
            }
            var childrenTrees: [Tree] = []
            for await childTree in childrenTreeGetterTaskGroup {
                childrenTrees.append(childTree)
            }
            return childrenTrees
        }
    }

    func convertToTreesRecursively(
        mirrorChild: Mirror.Child,
        registerChanges: Bool,
        sourceView: any View
    ) async -> Tree {
        do throws(TreeNodeValidationError) {
            try self.validateChild(mirrorChild)
        } catch {
            return await self.getValidatedChild(
                from: error,
                registerChanges: registerChanges
            )
        }

        var value = "\(mirrorChild.value)"

        self.transformIfNeeded(&value)

        let childTree = Tree(
            node: TreeNode(
                type: "\(type(of: mirrorChild.value))",
                label: mirrorChild.label ?? "<unknown>",
                value: value,
                serialNumber: await self.nodeSerialNumberCounter.counter,
                registerChanges: registerChanges
            )
        )
        childTree.children = await self.getChildrenTrees(
            mirror: Mirror(reflecting: mirrorChild.value),
            sourceView: sourceView,
            registerChanges: registerChanges
        )

        let maxChildCountForAutoCollapsingParentNodes = SwiftUIViewTreeConfiguration.shared.maxChildCountForAutoCollapsingParentNodes

        if maxChildCountForAutoCollapsingParentNodes != 0 && childTree.children.count >= maxChildCountForAutoCollapsingParentNodes  {
            CollapsedNodesStore.shared.collapse(nodeID: childTree.parentNode.id)
        }

        childTree.parentNode.descendantCount = self.getDescendantCount(of: childTree)

        return childTree
    }

    func validateChild(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        for validation in validationList {
            try validation.validate(child)
        }
    }

    func getValidatedChild(
        from treeNodeValidationError: TreeNodeValidationError,
        registerChanges: Bool
    ) async -> Tree {
        Tree(
            node: TreeNode(
                type: treeNodeValidationError.description,
                label: treeNodeValidationError.description,
                value: treeNodeValidationError.description,
                serialNumber: await nodeSerialNumberCounter.counter,
                registerChanges: registerChanges
            )
        )
    }

    func getDescendantCount(of tree: Tree) -> Int { //TODO: could we improve its performance somehow? memoization?
        tree.children.reduce(0) { total, child in
            total + 1 + getDescendantCount(of: child)
        }
    }

    func getRootTree(
        from rootView: any View,
        as rootNodeType: RootNodeType,
        registerChanges: Bool
    ) async -> Tree {
        let rootNode = getRootTreeNode(
            of: rootView,
            as: rootNodeType,
            registerChanges: registerChanges
        )
        let rootViewTree = Tree(node: rootNode)
        rootViewTree.children = await getChildrenTrees(
            mirror: Mirror(reflecting: rootView),
            sourceView: rootView,
            registerChanges: registerChanges
        )
        return rootViewTree
    }

    func getRootTreeNode(
        of view: any View,
        as rootNodeType: RootNodeType,
        registerChanges: Bool
    ) -> TreeNode {
        TreeNode(
            type: "\(type(of: view))",
            label: rootNodeType.rawValue,
            value: "\(view)",
            serialNumber: rootNodeType.serialNumber,
            registerChanges: registerChanges
        )
    }

    func transformIfNeeded(_ value: inout String) {
        /// Having these strings in the value makes it really hard to compare values, as they're different between parent and child views.
        let unwantedSubStringList = [
            " location:",
            " _location:"
        ]

        for unwantedSubString in unwantedSubStringList {
            if let locationRange = value.range(of: unwantedSubString) {
                let start = locationRange.upperBound

                let end = value[start...].endIndex

                value.replaceSubrange(start..<end, with: " " + TreeNodeValidationError.location.description)
            }
        }
    }
}
