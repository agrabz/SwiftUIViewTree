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

    //TODO: documentation
    func renderViewTree(of originalView: any View, maxDepth: Int = .max) -> some View {
        TreeContainer.shared.computeViewTree(
            maxDepth: maxDepth,
            originalView: originalView,
            modifiedView: self
        )
        return modifier(RenderViewTreeModifier())
    }
}
