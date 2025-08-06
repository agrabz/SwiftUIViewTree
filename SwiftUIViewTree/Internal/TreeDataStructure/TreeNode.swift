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

    init(type: String, label: String, value: String) {
        self.type = type
        self.label = label
        self.value = value
    }

    var id: String { //TODO: ID collision can happen with this setup so we'd need something else like position in tree or parent ID
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
