//
//  Tree.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Observation

@Observable
final class Tree: CustomStringConvertible, Equatable {
    let parentNode: TreeNode
    var children: [Tree] // TODO: parents with only one child should be merged with their children

    var description: String {  //TODO: to outsource to some mapper and test
        var description = parentNode.printDescription

        description += children
            .map { $0.description }
            .joined(separator: "\n")

        return description
    }

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.parentNode = node
        self.children = children
    }

    static func == (lhs: Tree, rhs: Tree) -> Bool {
        lhs.parentNode == rhs.parentNode &&
        lhs.children == rhs.children
    }
}
