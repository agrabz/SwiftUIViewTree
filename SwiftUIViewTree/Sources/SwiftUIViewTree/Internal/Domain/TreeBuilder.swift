
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

    func findMatchingSubtree(in root: Tree, matching target: Tree) -> (changed: Tree, original: Tree)? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if areSubtreesEqual(current, target) {
                return (current, target)
            }

            queue.append(contentsOf: current.children)
        }

        return nil
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
    mutating func convertToTreesRecursively( //TODO: to test, maybe it should be global function or just be somewhere else to make it usable for printViewTree?
        mirror: Mirror,
        source: any View,
    ) -> [Tree] {
        let result = mirror.children.enumerated().map { (index, child) in
            guard
                child.label != "location", //TODO: these types are changing between different views therefore their matching is really hard, and the easiest is to just rename them all <-- this logic here is wrong because it should be for all the 3 different strings and they should be named accordingly
                !"\(type(of: child.value))".starts(with: "AtomicBox"),
                !"\(type(of: child.value))".starts(with: "AtomicBuffer")
            else {
                return Tree(
                    node: TreeNode(
                        type: "SwiftUIViewTree.location",
                        label: "SwiftUIViewTree.location",
                        value: "SwiftUIViewTree.location",
                        serialNumber: nodeSerialNumberCounter.counter
                    )
                ) // as Any? see type(of:) docs
            }
            let childMirror = Mirror(reflecting: child.value)

            var value = "\(child.value)"

            if let locationRange = value.range(of: " location:") {
                let start = locationRange.upperBound

                let end = value[start...].endIndex

                value.replaceSubrange(start..<end, with: " SwiftUIViewTree.location") //TODO: constant
            }

            if let locationRange = value.range(of: " _location:") { //TODO: unify with the above one
                let start = locationRange.upperBound

                let end = value[start...].endIndex

                value.replaceSubrange(start..<end, with: " SwiftUIViewTree.location")
            }


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

    func areSubtreesEqual(_ lhs: Tree, _ rhs: Tree) -> Bool {
        guard
            lhs.parentNode.label == rhs.parentNode.label
        else {
//            print("labels NOT equal: \(lhs.parentNode.label) != \(rhs.parentNode.label)")
            return false
        }
//        print("labels IS equal: \(lhs.parentNode.label) != \(rhs.parentNode.label)")
        guard
            lhs.parentNode.type == rhs.parentNode.type
        else {
//            print("types NOT equal: \(lhs.parentNode.type) != \(rhs.parentNode.type)")
            return false
        }
//        print("types IS equal: \(lhs.parentNode.type) != \(rhs.parentNode.type)")

        for (leftChild, rightChild) in zip(lhs.children, rhs.children) {
            if !areSubtreesEqual(leftChild, rightChild) {
//                print("children NOT equal", leftChild.parentNode.label, rightChild.parentNode.label)
                return false
            }
//            print("children ARE equal", leftChild.parentNode.label, rightChild.parentNode.label)
        }

        return true
    }
}
