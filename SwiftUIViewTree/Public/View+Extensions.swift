//
//  View+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

public extension View {
    func printViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
        var tree = Tree(
            node: TreeNode(
                type: "Root node",
                label: "Root node",
                value: "Root node"
            )
        )
        tree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: self),
            maxDepth: maxDepth
        )

        print(tree)
        return self
    }


//    func renderViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
//        var tree = Tree(
//            node: TreeNode(
//                type: "Root node",
//                label: "Root node",
//                value: "Root node"
//            )
//        )
//        tree.children = convertToTreesRecursively(
//            mirror: Mirror(reflecting: self),
//            maxDepth: maxDepth
//        )
//
//        return TreeWindow(
//            originalContent: self,
//            treeBreakDownOfOriginalContent: tree
//        )
//    }

    func modi(maxDepth: Int = .max) -> some View {
        TreeContainer.shared.getit(maxDepth: maxDepth, source: self)
        return modifier(Modi(treeContainer: TreeContainer.shared))
//            .id(UUID())
    }
}

@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    var tree: Tree?

    func getit(maxDepth: Int, source: any View) {
        var tree = Tree(
            node: TreeNode(
                type: "Root node",
                label: "Root node",
                value: "Root node"
            )
        )
        tree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: source),
            maxDepth: maxDepth
        )

        if let selfTree = self.tree {
            self.tree?.children = tree.children //replace only what's needed
//            let diff = tree.children.difference(from: selfTree.children) { lhs, rhs in
//                lhs.node.id == rhs.node.id &&
//                lhs.node.type == rhs.node.type &&
//                lhs.node.label == rhs.node.label &&
//                lhs.node.value == rhs.node.value
//            }
////            if let diff {
//                let a = selfTree.children.applying(diff)
//            if let a {
//                self.tree?.children = a
//            }
//            }
        } else {
            self.tree = tree
        }
    }

}

struct Modi: ViewModifier {
    @State var treeContainer: TreeContainer

    func body(content: Content) -> some View {
        TreeWindow(
            originalContent: content,
            treeBreakDownOfOriginalContent: treeContainer.tree ?? .init(node: .init(type: "Sad", label: "Sad", value: "Sad"))
        )
//        .id(UUID())
    }
}
