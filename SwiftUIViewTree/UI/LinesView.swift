//
//  LinesView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct LinesView: View {
    let parent: Tree
    let nodeCenters: [UUID: Anchor<CGPoint>]

    private func pointFor(nodeID: UUID, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = nodeCenters[nodeID] else { return nil }
        return proxy[anchor]
    }
    
    private func lineFromParent(to child: Tree, in proxy: GeometryProxy) -> Line? {
        guard
            let startPoint = pointFor(
                nodeID: self.parent.node.id,
                in: proxy
            ),
            let endPoint = pointFor(
                nodeID: child.node.id,
                in: proxy
            )
        else {
            return nil
        }

        let lineBetweenStartAndEndPoints = Line(
            startPoint: startPoint,
            endPoint: endPoint
        )

        return lineBetweenStartAndEndPoints
    }
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(self.parent.children, id: \.node.id) { child in
                Group {
                    self.lineFromParent(
                        to: child,
                        in: proxy
                    )?.stroke()

                    LinesView(
                        parent: child,
                        nodeCenters: self.nodeCenters
                    )
                }
            }
        }
    }
}
