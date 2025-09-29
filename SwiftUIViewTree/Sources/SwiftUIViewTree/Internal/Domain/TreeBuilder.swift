
import SwiftUI

@MainActor
struct TreeBuilder {
    private var nodeSerialNumberCounter = NodeSerialNumberCounter()

    mutating func getTreeFrom(
        originalView: any View,
        modifiedView: any View,
    ) -> Tree {
        nodeSerialNumberCounter.reset()

        let newTree = Tree(
            node: .rootNode
        )

        let originalViewRootTree = getRootTree(
            from: originalView,
            as: .originalView,
        )
        newTree.children.append(originalViewRootTree)

        let modifiedViewRootTree = getRootTree(
            from: modifiedView,
            as: .modifiedView,
        )
        newTree.children.append(modifiedViewRootTree)

        return newTree
    }
}

private extension TreeBuilder {
    mutating func convertToTreesRecursively( //TODO: to test, maybe it should be global function or just be somewhere else to make it usable for printViewTree?
        mirror: Mirror,
        source: any View,
    ) -> [Tree] {
        let result = mirror.children.enumerated().map { (index, child) in
            let childMirror = Mirror(reflecting: child.value)

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: "\(child.value)",
                    serialNumber: nodeSerialNumberCounter.counter
                )
            ) // as Any? see type(of:) docs
            childTree.children = convertToTreesRecursively(
                mirror: childMirror,
                source: source
            )

            childTree.parentNode.descendantCount = getDescendantCount(of: childTree)

            return childTree
        }
        return result
    }

    func getDescendantCount(of tree: Tree) -> Int {
        tree.children.reduce(0) { total, child in
            total + 1 + getDescendantCount(of: child)
        }
    }

    mutating func getRootTree(from rootView: any View, as rootNodeType: RootNodeType) -> Tree {
        let rootNode = getRootTreeNode(of: rootView, as: rootNodeType)
        let rootViewTree = Tree(node: rootNode)
        rootViewTree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: rootView),
            source: rootView
        )
        return rootViewTree
    }

    func getRootTreeNode(of view: any View, as rootNodeType: RootNodeType) -> TreeNode {
        TreeNode(
            type: "\(type(of: view))",
            label: rootNodeType.rawValue,
            value: "\(view)",
            serialNumber: rootNodeType.serialNumber,
        )
    }
}
