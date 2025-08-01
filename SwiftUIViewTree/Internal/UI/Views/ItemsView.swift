//
//  ItemsView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct ItemsView<Content: View>: View {
    @State private var isPopoverPresented = false

    let tree: Tree
    let content: (TreeNode) -> Content

    var body: some View {
        VStack {
            Button { //TODO: there's a performance issue here (the more you're zoomed in the worse), every time the button is tapped, the whole view is redrawn
                isPopoverPresented.toggle()
            } label: {
                content(tree.node)
                    .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                        [self.tree.node.id: anchor]
                    }
            }
            .popover(isPresented: $isPopoverPresented) {
                NodePopover(node: tree.node)
            }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \.node.id) { child in
                    ItemsView(
                        tree: child,
                        content: self.content
                    )
                }
            }
        }
    }
}
