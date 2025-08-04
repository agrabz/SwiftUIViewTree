//
//  TreeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct TreeView: View, Equatable {
    static func == (lhs: TreeView, rhs: TreeView) -> Bool {
        lhs.tree == rhs.tree //TODO: zooms?
    }
    
    let tree: Tree
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0
    
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            ItemsView(tree: tree)
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
