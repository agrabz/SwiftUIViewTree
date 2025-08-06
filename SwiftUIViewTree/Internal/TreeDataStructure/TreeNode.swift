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
        if lhs.isParent && rhs.isParent {
            print("--- Both are parents", lhs.id, rhs.id)
            return false
        } else {
//            print("--- One of them is not a parent", lhs.id, rhs.id)
        }
        let a =
        lhs.id == rhs.id
        if !a {
            print(lhs.id, rhs.id)
        }
        return a
    }
    
    let type: String
    let label: String
    let value: String
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

    var id: String { //TODO: ID collision can happen with this setup so we'd need something else like position in tree or parent ID
//        "\(type)-\(label)-\(value)"
        """
        \(label.prefix(20))
        \(type.prefix(20)) \(value.prefix(20))
        """

    }

    var description: String {   //TODO: to outsource to some mapper and test
        """
        \(label.prefix(20))
        \(type.prefix(20)) \(value.prefix(20))
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
