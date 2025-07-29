//
//  TreeWindow.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct TreeWindow<Content: View>: View {
    let originalContent: Content
    let treeBreakDownOfOriginalContent: Tree

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    TreeView(tree: treeBreakDownOfOriginalContent) { value in
                        NodeView(value: value)
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
