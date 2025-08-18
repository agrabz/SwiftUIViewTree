import SwiftUI

@MainActor
@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

    func computeViewTree(maxDepth: Int, source: any View) {
        Task {
            switch uiState {
                case .computingTree:
                    break
                case .treeComputed:
                    withAnimation {
                        isRecomputing = true
                    }
            }

            let newTree = Tree(
                node: .rootNode
            )
            newTree.children = convertToTreesRecursively(
                mirror: Mirror(reflecting: source),
                maxDepth: maxDepth
            )

            // Uncomment this to simulate delay in computing the tree
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

            var childValue = "\(child.value)"
            if childValue == true.description {
                childValue = "true 123456789123456789123456789"
            } else if childValue == false.description {
                childValue = "false 123456789123456789123456789"
            }

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: childValue,
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
