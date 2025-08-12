import SwiftUI

public extension View {
    /// Left behind. Working out renderViewTree for now.
    func printViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
        let tree = Tree(
            node: .rootNode
        )
        tree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: self),
            maxDepth: maxDepth
        )

        print(tree)
        return self
    }

    func renderViewTree(maxDepth: Int = .max) -> some View {
        TreeContainer.shared.computeViewTree(
            maxDepth: maxDepth,
            source: self
        )
        return modifier(RenderViewTreeModifier(treeContainer: TreeContainer.shared))
    }
}

@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    var tree: Tree?

    func computeViewTree(maxDepth: Int, source: any View) {
        let newTree = Tree(
            node: .rootNode
        )
        newTree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: source),
            maxDepth: maxDepth
        )

        if self.tree != nil {
            self.tree?.children = newTree.children //replace only what's needed
        } else {
            self.tree = newTree
        }
    }
}

struct RenderViewTreeModifier: ViewModifier {
    @State var treeContainer: TreeContainer

    func body(content: Content) -> some View {
        TreeWindowScreen(
            originalContent: content,
            treeBreakDownOfOriginalContent: treeContainer.tree ?? .init(node: .rootNode)
        )
    }
}
