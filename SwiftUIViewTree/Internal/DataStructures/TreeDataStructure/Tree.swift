//
//  Tree.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

struct Tree: CustomStringConvertible {
    let node: TreeNode
    var children: [Tree] // TODO: parents with only one child should be merged with their children

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
