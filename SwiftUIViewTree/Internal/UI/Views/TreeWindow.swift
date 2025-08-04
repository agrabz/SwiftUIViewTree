//
//  TreeWindow.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct TreeWindow<Content: View>: View, Equatable {
    static func == (lhs: TreeWindow<Content>, rhs: TreeWindow<Content>) -> Bool {
        lhs.treeBreakDownOfOriginalContent == rhs.treeBreakDownOfOriginalContent
    }
    
    let originalContent: Content
    let treeBreakDownOfOriginalContent: Tree

    var body: some View {
        let _ = Self._printChanges()
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    TreeView(tree: treeBreakDownOfOriginalContent)
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
