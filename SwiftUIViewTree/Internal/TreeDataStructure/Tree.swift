//
//  Tree.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

@Observable
final class Tree: CustomStringConvertible/*, Equatable*/ {
    let node: TreeNode
    var children: [Tree]

    var description: String {  //TODO: to outsource to some mapper and test
        var description = node.printDescription

        description += children
            .map { $0.description }
            .joined(separator: "\n")

        return description
    }

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.node = node
        self.children = children
    }
}
