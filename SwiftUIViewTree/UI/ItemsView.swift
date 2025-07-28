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
    let id: KeyPath<TreeNode, UUID>
    let content: (String) -> Content
    
    var body: some View {
        VStack {
            Button {
                isPopoverPresented.toggle()
            } label: {
                content(tree.node.type)
                    .anchorPreference(key: CenterKey.self, value: .center) { anchor in
                        [self.tree.node[keyPath: self.id]: anchor]
                    }
            }
            .popover(isPresented: $isPopoverPresented) {
                ScrollView([.vertical, .horizontal]) {
                    VStack(alignment: .leading) {
                        Text("Type: \(tree.node.type)")
                        Text("Label: \(tree.node.label)")
                        Text("Value: \(tree.node.value)")
                    }
                    .padding(.horizontal)
                }
                .presentationCompactAdaptation(.popover)
            }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \.node.id) { child in
                    ItemsView(tree: child, id: self.id, content: self.content)
                }
            }
        }
    }
}
