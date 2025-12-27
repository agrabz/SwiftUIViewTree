
import AsyncAlgorithms
import SwiftUI

@MainActor
final class TreeBuilder {
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
    func convertToTreesRecursively(
        mirror: Mirror,
        source: any View,
        registerChanges: Bool
    ) async -> [Tree] {
        let result = mirror.children.enumerated().async.map { [weak self] (index, child) in
            do throws(TreeNodeValidationError) {
                let list = await self?.validationList ?? []
                for validation in list {
                    try validation.validate(child)
                }
            } catch {
                return await self?.getValidatedChild(
                    from: error,
                    registerChanges: registerChanges
                )
            }

            let childMirror = Mirror(reflecting: child.value)

            var value = "\(child.value)"

            await self?.transformIfNeeded(&value)

            let childTree = await Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: value,
                    serialNumber: await self?.nodeSerialNumberCounter.counter ?? 42, //TODO: ehh
                    registerChanges: registerChanges
                )
            )
            childTree.children = await self?.convertToTreesRecursively(
                mirror: childMirror,
                source: source,
                registerChanges: registerChanges
            ) ?? []  //TODO: ehh

            await childTree.parentNode.descendantCount = await self?.getDescendantCount(of: childTree) ?? 0  //TODO: ehh

            return childTree
        }
        var treeList: [Tree] = []
        for await a in result {
            if let a {
                treeList.append(a)
            }
        }
        return treeList
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

    func getDescendantCount(of tree: Tree) -> Int { //TODO: this is really heavy
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
        rootViewTree.children = await convertToTreesRecursively(
            mirror: Mirror(reflecting: rootView),
            source: rootView,
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
