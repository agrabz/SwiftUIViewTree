//
//  View+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

public extension View {
    func printViewTree(maxDepth: Int = .max) -> some View {
        Mirror(reflecting: self).printRecursively()
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

        return GeometryReader { geometry in
            HStack {
                self
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    TreeView(
                        tree: tree,
                        id: \.id
                    ) { value in
                        Text(value)
                            .background()
                            .padding()
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
