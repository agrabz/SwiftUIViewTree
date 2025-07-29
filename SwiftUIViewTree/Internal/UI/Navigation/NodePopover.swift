//
//  NodePopover.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct NodePopover: View {
    let node: TreeNode

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            VStack(alignment: .leading) {
                Text("Type: \(node.type)")
                Text("Label: \(node.label)")
                Text("Value: \(node.value)")
            }
            .padding(.all, 8)
        }
        .presentationCompactAdaptation(.popover)
    }
}
