import SwiftUI

@MainActor
@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false

    func computeViewTree(maxDepth: Int, source: any View) {
        print("---1")
        Task {
            switch uiState {
                case .computingTree:
                    print("---2")
                    break
                case .treeComputed:
                    print("---3")
                    withAnimation {
                        print("---4")
                        isRecomputing = true
                        print("---5")
                    }
            }

            print("---6")
            let newTree = Tree(
                node: .rootNode
            )
            print("---7")
            newTree.children = convertToTreesRecursively(
                mirror: Mirror(reflecting: source),
                maxDepth: maxDepth
            )
            print("---8")

            // (Un)comment this to simulate delay in computing the tree
            try? await Task.sleep(for: .seconds(1))
            print("---9")

            withAnimation {
                print("---10")
                isRecomputing = false
                print("---11")
            }

            print("---12")
            switch uiState {
                case .computingTree:
                    print("---13")
                    withAnimation(.easeInOut(duration: 1)) {
                        print("---14")
                        self.uiState = .treeComputed(
                            .init(
                                treeBreakDownOfOriginalContent: newTree
                            )
                        )
                        print("---15")
                    }
                case .treeComputed(let computedUIState):
                    print("---16")
                    computedUIState.treeBreakDownOfOriginalContent.children = newTree.children //once this change is done, the whole view gets recalculated which takes significant time. Caching? Different tree implementation - expandable nodes?
                    print("---17")
                    withAnimation(.easeInOut(duration: 1)) {
                        print("---18")
                        self.uiState = .treeComputed(computedUIState) //replace only what's needed, better diffing
                        print("---19")
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
                maxDepth: maxDepth,
                currentDepth: currentDepth + 1
            )
            return childTree
        }
        return result
    }
}
