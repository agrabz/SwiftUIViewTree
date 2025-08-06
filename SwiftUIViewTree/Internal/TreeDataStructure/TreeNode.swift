//
//  TreeNode.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import Foundation

@Observable
final class TreeNode: Equatable {
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
//        print("Equatable")
        if lhs.value == "true" {
            print(lhs.id, lhs.isParent, rhs.isParent)
        }
        if lhs.isParent && rhs.isParent {
            return false
        }
        let a = lhs.id == rhs.id
        if !a {
            print("--lhs \(lhs.id)\n\n--rhs \(rhs.id)")
        }
        return a
    }
    
    let type: String
    let label: String
    var value: String
    let isParent: Bool

    init(
        type: String,
        label: String,
        value: String,
        isParent: Bool
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.isParent = isParent
    }

    var id: String {
        "\(type)-\(label)-\(value)"
    }

    var description: String {   //TODO: to outsource to some mapper and test
        """
        \(type)
        \(label) \(value)
        """
    }

//    var printDescription: String {   //TODO: to outsource to some mapper and test
//        """
//        
//        Node
//        type: \(type)
//        label: \(label)
//        value: \(value)
//        
//        """
//    }
}
