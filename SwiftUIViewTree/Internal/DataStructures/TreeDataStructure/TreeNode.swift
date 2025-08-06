//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

struct TreeNode: Equatable {
    let id: UUID = UUID()
    let type: ShortenableString
    let label: String
    let value: ShortenableString
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String

    var printDescription: String {   //TODO: to outsource to some mapper and test
        """
        
        Node
        type: \(type)
        label: \(label)
        value: \(value)
        
        """
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: .init(fullString: "Root node"),
        label: "Root node",
        value: .init(fullString: "Root node"),
        displayStyle: "Root node",
        subjectType: "Root node",
        superclassMirror: "Root node",
        mirrorDescription: "Root node"
    )
}
