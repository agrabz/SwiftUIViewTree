import SwiftUI

struct LinesView: View {
    let parentTree: Tree
    let nodeCenters: [TreeNode.ID: Anchor<CGPoint>] //TODO: ID collision can happen with this setup so we'd need something else like position in tree or parent ID

   var body: some View {
        GeometryReader { proxy in
            ForEach(self.parentTree.children, id: \.parentNode.id) { childTree in
                Group {
                    self.lineFromParent(
                        to: childTree,
                        in: proxy
                    )?.stroke(.black, lineWidth: 3.0)

                    LinesView(
                        parentTree: childTree,
                        nodeCenters: self.nodeCenters
                    )
                }
            }
        }
    }
}

private extension LinesView {
    func pointFor(nodeID: TreeNode.ID, in proxy: GeometryProxy) -> CGPoint? { //TODO: to test?
        guard let anchor = nodeCenters[nodeID] else { return nil }
        return proxy[anchor]
    }

    func lineFromParent(to childTree: Tree, in proxy: GeometryProxy) -> Line? { //TODO: to test?
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


}
