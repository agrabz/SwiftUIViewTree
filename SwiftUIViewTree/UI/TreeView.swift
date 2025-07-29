//
//  TreeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct TreeView<Content: View>: View {
    let tree: Tree
    let id: KeyPath<TreeNode, UUID>
    let content: (String) -> Content
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0


    public init(
        tree: Tree,
        id: KeyPath<TreeNode, UUID>,
        content: @escaping (String) -> Content
    ) {
        self.tree = tree
        self.id = id
        print("Ákos", id)
        self.content = content
    }
    
    public var body: some View {
        ScrollView([.vertical, .horizontal]) {
            ItemsView(tree: tree, id: id, content: content)
                .backgroundPreferenceValue(CenterKey.self) {
                    LinesView(parent: self.tree, id: self.id, centers: $0)
                }
                .scaleEffect(totalZoom + currentZoom)
        }
        .simultaneousGesture(
            MagnifyGesture()
                .onChanged { value in
                    currentZoom = value.magnification - 1
                }
                .onEnded { value in
                    totalZoom += currentZoom
                    currentZoom = 0
                }
        )
        .background(
            LinearGradient(
                gradient:
                    Gradient(
                        colors: [
                            Color(red: 0.2, green: 0.6, blue: 1.0),  // Swift blue
                            Color(red: 0.0, green: 0.8, blue: 0.8)   // Teal
                        ]
                    ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
