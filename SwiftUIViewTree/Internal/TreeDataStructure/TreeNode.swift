//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

@Observable
final class TreeNode/*: Equatable*/ {
    let id: UUID = UUID()
    let type: String
    let label: String
    let value: String

    init(type: String, label: String, value: String) {
        self.type = type
        self.label = label
        self.value = value
    }

    var description: String {   //TODO: to outsource to some mapper and test
        """
        \(type)
        \(label) \(value)
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
