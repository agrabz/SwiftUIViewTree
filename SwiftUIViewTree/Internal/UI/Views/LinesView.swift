import SwiftUI

struct LinesView: View {
    let parentTree: Tree
    let nodeCenters: [String: Anchor<CGPoint>] //TODO: ID collision can happen with this setup so we'd need something else like position in tree or parent ID

    private func pointFor(nodeID: String, in proxy: GeometryProxy) -> CGPoint? { //TODO: to test?
        guard let anchor = nodeCenters[nodeID] else { return nil }
        return proxy[anchor]
    }
    
    private func lineFromParent(to childTree: Tree, in proxy: GeometryProxy) -> Line? { //TODO: to test?
        guard
            let startPoint = pointFor(
                nodeID: self.parentTree.parentNode.id,
                in: proxy
            ),
            let endPoint = pointFor(
                nodeID: childTree.parentNode.id,
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
            ForEach(self.parentTree.children, id: \.parentNode.id) { childTree in
                Group {
                    self.lineFromParent(
                        to: childTree,
                        in: proxy
                    )?.stroke()

                    LinesView(
                        parentTree: childTree,
                        nodeCenters: self.nodeCenters
                    )
                }
            }
        }
    }
}
