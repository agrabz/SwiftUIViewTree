import SwiftUI

@MainActor
@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

    func computeViewTree(
        maxDepth: Int,
        originalView: any View,
        modifiedView: any View
    ) {
        Task {
            switch uiState {
                case .computingTree:
                    break
                case .treeComputed:
                    withAnimation {
                        isRecomputing = true
                    }
            }

            let newTree = getTreeFrom(originalView: originalView, modifiedView: modifiedView, maxDepth: maxDepth)

            // (Un)comment this to simulate delay in computing the tree
            try? await Task.sleep(for: .seconds(1))

            withAnimation {
                isRecomputing = false
            }

            switch uiState {
                case .computingTree:
                    withAnimation(.easeInOut(duration: 1)) {
                        self.uiState = .treeComputed(
                            .init(
                                treeBreakDownOfOriginalContent: newTree
                            )
                        )
                    }
                case .treeComputed(let computedUIState):
                    computedUIState.treeBreakDownOfOriginalContent.children = newTree.children //once this change is done, the whole view gets recalculated which takes significant time. Caching? Different tree implementation - expandable nodes?
                    withAnimation(.easeInOut(duration: 1)) {
                        self.uiState = .treeComputed(computedUIState) //replace only what's needed, better diffing
                    }
            }
        }
    }
}

private extension TreeContainer {
    func getTreeFrom(
        originalView: any View,
        modifiedView: any View,
        maxDepth: Int
    ) -> Tree {
        let newTree = Tree(
            node: .rootNode
        )

        let originalViewRootNode = getRootTreeNode(of: originalView, as: .originalView)

        newTree.children.append(Tree(node: originalViewRootNode))

        newTree.children[0].children = convertToTreesRecursively(
            mirror: Mirror(reflecting: originalView),
            source: originalView,
            maxDepth: maxDepth
        )

        let modifiedViewRootNode = getRootTreeNode(of: modifiedView, as: .modifiedView)

        newTree.children.append(Tree(node: modifiedViewRootNode))

        newTree.children[1].children = convertToTreesRecursively(
            mirror: Mirror(reflecting: modifiedView),
            source: modifiedView,
            maxDepth: maxDepth
        )

        return newTree
    }

    func convertToTreesRecursively( //TODO: to test, maybe it should be global function or just be somewhere else to make it usable for printViewTree?
        mirror: Mirror,
        source: any View,
        maxDepth: Int = .max,
        currentDepth: Int = 0
    ) -> [Tree] {
        guard currentDepth < maxDepth else {
            return []
        }

        //        print()
        //        print(source)
        //        print()

        let result = mirror.children.enumerated().map { (index, child) in
            let childMirror = Mirror(reflecting: child.value)

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: "\(child.value)",
                    displayStyle: String(describing: childMirror.displayStyle),
                    subjectType: "\(childMirror.subjectType)",
                    superclassMirror: String(describing: childMirror.superclassMirror),
                    mirrorDescription: childMirror.description,
                    childIndex: index,
                    isParent: childMirror.children.count > 0
                )
            ) // as Any? see type(of:) docs
            childTree.children = convertToTreesRecursively(
                mirror: childMirror,
                source: source,
                maxDepth: maxDepth,
                currentDepth: currentDepth + 1
            )
            return childTree
        }
        return result
    }

    func getRootTreeNode(of view: any View, as rootNodeType: RootNodeType) -> TreeNode {
        let viewMirror = Mirror(reflecting: view)

        let rootNode = TreeNode(
            type: "\(type(of: view))",
            label: rootNodeType.rawValue,
            value: "\(view)",
            displayStyle: "\(String(describing: viewMirror.displayStyle))",
            subjectType: "\(viewMirror.subjectType)",
            superclassMirror: String(describing: viewMirror.superclassMirror),
            mirrorDescription: viewMirror.description,
            childIndex: 0,
            isParent: viewMirror.children.count > 0
        )

        return rootNode
    }
}

enum RootNodeType: String {
    case originalView
    case modifiedView
}
