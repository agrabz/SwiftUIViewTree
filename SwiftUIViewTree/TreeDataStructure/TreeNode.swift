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

    var description: String {
        """
        \(type)
        \(label)
        """
    }

    var printDescription: String {
        """
        
        Node
        type: \(type)
        label: \(label)
        value: \(value)
        
        """
    }
}
