import SwiftUI

public extension View {
    /// Left behind. Working out renderViewTree for now.
//    func printViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
//        let tree = Tree(
//            node: .rootNode
//        )
//        tree.children = TreeContainer.shared.convertToTreesRecursively(
//            mirror: Mirror(reflecting: self),
//            maxDepth: maxDepth
//        )
//
//        print(tree)
//        return self
//    }

    func renderViewTree(maxDepth: Int = .max) -> some View {
        TreeContainer.shared.computeViewTree(
            maxDepth: maxDepth,
            source: self
        )
        return modifier(RenderViewTreeModifier(treeContainer: TreeContainer.shared))
    }
}
