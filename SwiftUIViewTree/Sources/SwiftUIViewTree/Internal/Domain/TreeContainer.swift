import SwiftUI

@MainActor
@Observable
final class TreeContainer {
    static var shared: TreeContainer = .init()
    // Change this value to simulate longer/shorter computation times
    static let waitTimeInSeconds = 1.0
    private(set) var uiState: TreeWindowUIModel = .computingTree
    private(set) var isRecomputing = false
    private var nodeSerialNumberCounter = NodeSerialNumberCounter()

    func computeViewTree(
        maxDepth: Int,
        originalView: any View,
        modifiedView: any View
    ) {
        //TODO: review if this Task can be placed somewhere else, so we might not need the sleep below?
        Task {
            switch uiState {
                case .computingTree:
                    break
                case .treeComputed:
                    withAnimation {
                        isRecomputing = true
                    }
            }

            let newTree = getTreeFrom(
                originalView: originalView,
                modifiedView: modifiedView,
                maxDepth: maxDepth
            )

            //TODO: without this delay, the view doesn't update properly in some cases (small-medium views only?)
            try? await Task.sleep(for: .seconds(Self.waitTimeInSeconds))

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
                    for changedValue in TreeNodeMemoizer.shared.allChangedNodes {
                        withAnimation {
                            computedUIState
                                .treeBreakDownOfOriginalContent[changedValue.serialNumber]?.value = changedValue.value
                        }
                    }
            }
        }
    }
}

private extension TreeContainer { //TODO: semantically this is not a TreeContainer responsibility, rather a TreeBuilder or similar
    func getTreeFrom(
        originalView: any View,
        modifiedView: any View,
        maxDepth: Int
    ) -> Tree {
        nodeSerialNumberCounter.reset()

        let newTree = Tree(
            node: .rootNode
        )

        let originalViewRootTree = getRootTree(
            from: originalView,
            as: .originalView,
            maxDepth: maxDepth
        )
        newTree.children.append(originalViewRootTree)

        let modifiedViewRootTree = getRootTree(
            from: modifiedView,
            as: .modifiedView,
            maxDepth: maxDepth
        )
        newTree.children.append(modifiedViewRootTree)

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

        let result = mirror.children.enumerated().map { (index, child) in
            let childMirror = Mirror(reflecting: child.value)

            let childTree = Tree(
                node: TreeNode(
                    type: "\(type(of: child.value))",
                    label: child.label ?? "<unknown>",
                    value: "\(child.value)",
                    serialNumber: nodeSerialNumberCounter.counter,
                    childrenCount: childMirror.children.count
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

    func getRootTree(from rootView: any View, as rootNodeType: RootNodeType, maxDepth: Int) -> Tree {
        let rootNode = getRootTreeNode(of: rootView, as: rootNodeType)
        let rootViewTree = Tree(node: rootNode)
        rootViewTree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: rootView),
            source: rootView,
            maxDepth: maxDepth
        )
        return rootViewTree
    }

    func getRootTreeNode(of view: any View, as rootNodeType: RootNodeType) -> TreeNode {
        let viewMirror = Mirror(reflecting: view)

        let rootNode = TreeNode(
            type: "\(type(of: view))",
            label: rootNodeType.rawValue,
            value: "\(view)",
            serialNumber: rootNodeType.serialNumber,
            childrenCount: viewMirror.children.count
        )

        return rootNode
    }
}

enum RootNodeType: String {
    case originalView
    case modifiedView

    var serialNumber: Int {
        switch self {
            case .originalView:
                -2
            case .modifiedView:
                -3
        }
    }
}
