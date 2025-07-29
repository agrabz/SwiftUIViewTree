//
//  View+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

public extension View {
    func printViewTree(maxDepth: Int = .max) -> some View {
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


    func renderViewTree(maxDepth: Int = .max) -> some View {
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

        return TreeWindow(
            originalContent: self,
            treeBreakDownOfOriginalContent: tree
        )
    }
}
