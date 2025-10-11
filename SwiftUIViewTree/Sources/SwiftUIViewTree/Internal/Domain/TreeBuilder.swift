
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

//    func merge(fullTree: Tree, subViewTree: Tree) -> Tree {
//        /// traverse fullTree with BFS until parentNode == subViewTree.parentNode
//        let matchingSubtree = findMatchingSubtree(in: fullTree, matching: subViewTree) ?? subViewTree
//        return matchingSubtree
//    }

    func findMatchingSubtree(in root: Tree, matching target: Tree) -> Tree? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            // 1️⃣ Check if current node could be the root of the target subtree
            if areSubtreesEqual(current, target) {
                return current
            }

            // 2️⃣ Continue BFS
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
                child.label != "location",
                !"\(type(of: child.value))".starts(with: "AtomicBox"),
                !"\(type(of: child.value))".starts(with: "AtomicBuffer")
            else {
                print()
                print("!!location or atomic found!!")
                print()
                return Tree(
                    node: TreeNode(
                        type: "location",
                        label: "location",
                        value: "location",
                        serialNumber: nodeSerialNumberCounter.counter
                    )
                ) // as Any? see type(of:) docs
            }
            let childMirror = Mirror(reflecting: child.value)

            var value = "\(child.value)"
            /// if type contains "location:" then replace the part between "location:" and the first comma "," after "location:", with string "SwiftUIViewTree.location"

            if let locationRange = value.range(of: " location:") {
                print("found location:")
                // Start searching *after* "location:"
                let start = locationRange.upperBound

                // Find the first comma or closing parenthesis after it
                let end = value[start...].endIndex //.firstIndex(where: { $0 == "," || $0 == ")" })

//                if let end = end {
                    // Replace the substring between "location:" and that symbol
                    value.replaceSubrange(start..<end, with: " SwiftUIViewTree.location")
//                } else {
//                    // If neither comma nor parenthesis found, replace until the end
//                    value.replaceSubrange(start..<value.endIndex, with: " SwiftUIViewTree.location")
//                }
            }

            if let locationRange = value.range(of: " _location:") {
                print("found _location:")
                // Start searching *after* "location:"
                let start = locationRange.upperBound

                // Find the first comma or closing parenthesis after it
                let end = value[start...].endIndex //.firstIndex(where: { $0 == "," || $0 == ")" })

//                if let end = end {
                    // Replace the substring between "location:" and that symbol
                    value.replaceSubrange(start..<end, with: " SwiftUIViewTree.location")
//                } else {
//                    // If neither comma nor parenthesis found, replace until the end
//                    value.replaceSubrange(start..<value.endIndex, with: " SwiftUIViewTree.location")
//                }
            }

//            print(value)


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
            print(
                childTree.parentNode.serialNumber,
                childTree.parentNode.label,
                childTree.parentNode.type,
                childTree.parentNode.value,
                childTree.parentNode.descendantCount,
            )

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
        // Compare the nodes themselves
        guard
            lhs.parentNode.label == rhs.parentNode.label
        else {
            print("labels NOT equal: \(lhs.parentNode.label) != \(rhs.parentNode.label)")
            return false
        }
        print("labels IS equal: \(lhs.parentNode.label) != \(rhs.parentNode.label)")
        guard
            lhs.parentNode.type == rhs.parentNode.type
        else {
            print("types NOT equal: \(lhs.parentNode.type) != \(rhs.parentNode.type)")
            return false
        }
        print("types IS equal: \(lhs.parentNode.type) != \(rhs.parentNode.type)")

        // Recursively compare children one-by-one
        for (leftChild, rightChild) in zip(lhs.children, rhs.children) {
            if !areSubtreesEqual(leftChild, rightChild) {
                print("children NOT equal", leftChild.parentNode.label, rightChild.parentNode.label)
                return false
            }
            print("children ARE equal", leftChild.parentNode.label, rightChild.parentNode.label)
        }

        return true
    }
}
