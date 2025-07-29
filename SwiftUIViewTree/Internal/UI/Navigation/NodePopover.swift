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
                Text("Type: \(node.type)")   //TODO: to come from node object or from a separate UIModel whose mapper is testable
                Text("Label: \(node.label)")
                Text("Value: \(node.value)")
                Text("DisplayStyle: \(node.displayStyle)")
                Text("SubjectType: \(node.subjectType)")
                Text("SuperclassMirror: \(node.superclassMirror)")
                Text("mirrorDescription: \(node.mirrorDescription)")
            }
            .padding(.all, 8)
        }
        .presentationCompactAdaptation(.popover)
    }
}
