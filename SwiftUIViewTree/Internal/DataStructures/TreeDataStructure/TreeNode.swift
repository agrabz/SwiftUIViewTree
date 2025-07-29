//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

struct TreeNode {
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
