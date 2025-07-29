//
//  TreeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct TreeView<Content: View>: View {
    let tree: Tree
    let content: (TreeNode) -> Content
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0

    init(
        tree: Tree,
        content: @escaping (TreeNode) -> Content
    ) {
        self.tree = tree
        self.content = content
    }
    
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            ItemsView(tree: tree, content: content)
                .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                    LinesView(
                        parent: self.tree,
                        nodeCenters: nodeCenters
                    )
                }
                .scaleEffect(totalZoom + currentZoom)
        }
        .simultaneousGesture(
            StatefulMagnifyGesture(
                currentZoom: $currentZoom,
                totalZoom: $totalZoom
            )
        )
        .background(
            LinearGradient(
                gradient:
                    Gradient(
                        colors: [
                            .blue,
                            .teal
                        ]
                    ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
