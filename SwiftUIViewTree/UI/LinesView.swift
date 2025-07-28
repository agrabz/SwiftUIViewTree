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

    private func point(for value: TreeNode, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = centers[id(value)] else { return nil }
        return proxy[anchor]
    }
    
    private func line(to child: Tree, in proxy: GeometryProxy) -> Line? {
        guard let start = point(for: tree.node, in: proxy) else { return nil }
        guard let end = point(for: child.node, in: proxy) else { return nil }
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
