//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

@Observable
final class TreeNode: Equatable {
    let type: ShortenableString
    let label: String
    let value: ShortenableString
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String

    var id: String {
        "\(type.fullString)-\(label)-\(value.fullString)"
    }

    #warning("in test branch there is a plain description which is used in NodeView and Popover")
    var printDescription: String {   //TODO: to outsource to some mapper and test
        """
        
        Node
        type: \(type)
        label: \(label)
        value: \(value)
        
        """
    }

    init(
        type: ShortenableString,
        label: String,
        value: ShortenableString,
        displayStyle: String,
        subjectType: String,
        superclassMirror: String,
        mirrorDescription: String
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.displayStyle = displayStyle
        self.subjectType = subjectType
        self.superclassMirror = superclassMirror
        self.mirrorDescription = mirrorDescription
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        let a =
        lhs.id == rhs.id
        if !a {
            print(lhs.id, rhs.id)
        }
        return a
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
