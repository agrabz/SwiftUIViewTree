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
            node: TreeNode( //TODO: root node thingy looks annoying
                type: ShortenableString(fullString: "Root node"),
                label: "Root node",
                value: ShortenableString(fullString: "Root node"),
                displayStyle: "Root node",
                subjectType: "Root node",
                superclassMirror: "Root node",
                mirrorDescription: "Root node"
            )
        )
        tree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: self),
            maxDepth: maxDepth
        )

        print(tree)
        return self
    }


    func renderViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
        return TreeWindowScreen(
            viewModel: TreeWindowViewModel(
                source: self,
                maxDepth: maxDepth
            ),
            originalContent: self
        )
    }
}
