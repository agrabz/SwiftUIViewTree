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
    @State private var itemsViewSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero

    init(
        tree: Tree,
        content: @escaping (TreeNode) -> Content
    ) {
        self.tree = tree
        self.content = content
    }

    var body: some View {
        GeometryReader { scrollProxy in
            ScrollView([.vertical, .horizontal]) {
                ItemsView(tree: tree, content: content)
                    .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                        LinesView(
                            parent: self.tree,
                            nodeCenters: nodeCenters
                        )
                    }
                    .scaleEffect(totalZoom + currentZoom)
                    .background(
                        GeometryReader { itemsProxy in
                            Color.clear
                                .onAppear {
                                    self.itemsViewSize = itemsProxy.size
                                    self.scrollViewSize = scrollProxy.size
                                    self.updateInitialZoom()
                                }
                                .onChange(of: itemsProxy.size) { _ in
                                    self.itemsViewSize = itemsProxy.size
                                    self.updateInitialZoom()
                                }
                        }
                    )
            }
            .onAppear {
                self.scrollViewSize = scrollProxy.size
                self.updateInitialZoom()
            }
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

    private func updateInitialZoom() {
        guard itemsViewSize.width > 0, itemsViewSize.height > 0, scrollViewSize.width > 0, scrollViewSize.height > 0 else { return }
        let scaleX = scrollViewSize.width / itemsViewSize.width
        let scaleY = scrollViewSize.height / itemsViewSize.height
        let minScale = min(scaleX, scaleY, 1.0) // Don't zoom in by default
        if abs(totalZoom - minScale) > 0.01 {
            totalZoom = minScale
        }
    }
}
