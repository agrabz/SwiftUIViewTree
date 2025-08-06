//
//  Tree.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

@Observable
final class Tree: CustomStringConvertible, Equatable {
    static func == (lhs: Tree, rhs: Tree) -> Bool {
        lhs.node == rhs.node &&
        lhs.children == rhs.children
    }
    
    let node: TreeNode
    var children: [Tree]

    var description: String {  //TODO: to outsource to some mapper and test
        var description = node.description

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
