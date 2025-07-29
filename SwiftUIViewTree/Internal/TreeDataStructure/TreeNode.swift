//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

struct TreeNode {
    let id: UUID = UUID()
    let type: String
    let label: String
    let value: String
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String

    var description: String {   //TODO: to outsource to some mapper and test
        """
        \(type)
        \(label)
        """
    }

    var printDescription: String {   //TODO: to outsource to some mapper and test
        """
        
        Node
        type: \(type)
        label: \(label)
        value: \(value)
        
        """
    }
}
