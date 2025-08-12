import SwiftUI

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

private extension TreeContainer {
    func convertToTreesRecursively( //TODO: to test, maybe it should be global function or just be somewhere else to make it usable for printViewTree?
        mirror: Mirror,
        maxDepth: Int = .max,
        currentDepth: Int = 0
    ) -> [Tree] {
        guard currentDepth < maxDepth else {
            return []
        }

        let result = mirror.children.map { child in
            let childMirror = Mirror(reflecting: child.value)

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: "\(child.value)",
                    //                displayStyle: String(describing: childMirror.displayStyle),
                    //                subjectType: "\(childMirror.subjectType)",
                    //                superclassMirror: String(describing: childMirror.superclassMirror),
                    //                mirrorDescription: childMirror.description,
                    isParent: childMirror.children.count > 0
                )
            ) // as Any? see type(of:) docs
            childTree.children = convertToTreesRecursively(
                mirror: childMirror,
                maxDepth: maxDepth,
                currentDepth: currentDepth + 1
            )
            return childTree
        }
        return result
    }
}
