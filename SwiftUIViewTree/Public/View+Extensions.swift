//
//  View+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

public extension View {
    func printViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
        var tree = Tree(
            node: TreeNode( //TODO: root node thingy looks annoying
                type: ShortenableString(fullString: "Root node"),
                label: "Root node",
                value: ShortenableString(fullString: "Root node"),
                displayStyle: "Root node",
                subjectType: "Root node",
                superclassMirror: "Root node",
                mirrorDescription: "Root node"
                          )
        )
        tree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: self),
            maxDepth: maxDepth
        )

        print(tree)
        return self
    }


//    func renderViewTree(maxDepth: Int = .max) -> some View { //TODO: to test
//        TreeWindowScreen(
//            viewModel: TreeWindowViewModel(
//                source: self,
//                maxDepth: maxDepth
//            ),
//            originalContent: self
//        )
//        .id(UUID()) // Force re-initialization on every state change
//    }

    func modi(maxDepth: Int = .max) -> some View {
        TreeContainer.shared.getit(maxDepth: maxDepth, source: self)
        return modifier(Modi(treeContainer: TreeContainer.shared))
        //            .id(UUID())
    }
}

//TODO: copy over from testbranch the changes to re-render only the changed nodes

@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    var tree: Tree?

    func getit(maxDepth: Int, source: any View) {
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

struct Modi: ViewModifier {
    @State var treeContainer: TreeContainer

    func body(content: Content) -> some View {
        TreeWindowScreen(
            originalContent: content,
            treeBreakDownOfOriginalContent: treeContainer.tree ?? .init(node: .rootNode)
        )
        //        .id(UUID())
    }
}
