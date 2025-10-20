
import SwiftUI

@MainActor
struct TreeBuilder {
    private let validationList: [any TreeNodeValidatorProtocol] = [
        LocationLabelTreeNodeValidator(),
        AtomicBoxTypeTreeNodeValidator(),
        AtomicBufferTypeTreeNodeValidator(),
    ]
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

    func flatten(_ treeToFlatten: Tree) -> [TreeNode] {
        var flattenedTree: [TreeNode] = []

        flattenedTree.append(treeToFlatten.parentNode)

        for child in treeToFlatten.children {
            flattenedTree.append(
                contentsOf: flatten(child)
            )
        }
        
        return flattenedTree
    }
}

private extension TreeBuilder {
    mutating func convertToTreesRecursively(
        mirror: Mirror,
        source: any View,
    ) -> [Tree] {
        let result = mirror.children.enumerated().map { (index, child) in
            for validation in validationList {
                do throws(TreeNodeValidationError) {
                    try validation.validate(child)
                } catch {
                    return Tree(
                        node: TreeNode(
                            type: error.description,
                            label: error.description,
                            value: error.description,
                            serialNumber: nodeSerialNumberCounter.counter
                        )
                    )
                }
            }

            let childMirror = Mirror(reflecting: child.value)

            var value = "\(child.value)"

            self.transformIfNeeded(&value)

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: value,
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
