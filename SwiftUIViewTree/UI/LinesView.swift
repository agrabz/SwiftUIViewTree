//
//  LinesView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct LinesView: View {
    let tree: Tree
    let id: KeyPath<TreeNode, UUID>
    let centers: [UUID: Anchor<CGPoint>]

    private func pointFor(nodeID: UUID, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = centers[nodeID] else { return nil }
        return proxy[anchor]
    }
    
    private func line(to child: Tree, in proxy: GeometryProxy) -> Line? {
        guard
            let start = pointFor(nodeID: tree.node.id, in: proxy),
            let end = pointFor(nodeID: child.node.id, in: proxy)
        else { return nil }
        return Line(start: start, end: end)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(self.tree.children, id: \.node.id) { child in
                Group {
                    self.line(
                        to: child,
                        in: proxy
                    )?.stroke()

                    LinesView(
                        tree: child,
                        id: self.id,
                        centers: self.centers
                    )
                }
            }
        }
    }
}
