//
//  ItemsView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct ItemsView: View {
//    static func == (lhs: ItemsView, rhs: ItemsView) -> Bool {
//        lhs.tree == rhs.tree
//    }

    @State private var isPopoverPresented = false

    let tree: Tree

    var body: some View {
        VStack {
            Button { //TODO: there's a performance issue here (the more you're zoomed in the worse), every time the button is tapped, the whole view is redrawn
                isPopoverPresented.toggle()
            } label: {
                NodeView(node: tree.parentNode.description)
                    .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                        [self.tree.parentNode.id: anchor]
                    }
            }
            .popover(isPresented: $isPopoverPresented) {
                NodePopover(node: tree.parentNode)
            }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \.parentNode.id) { child in
                    ItemsView(tree: child)
                }
            }
        }
    }
}
