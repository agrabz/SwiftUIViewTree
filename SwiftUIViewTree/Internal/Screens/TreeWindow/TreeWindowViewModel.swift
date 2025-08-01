//
//  TreeWindowViewModel.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

@MainActor
@Observable
final class TreeWindowViewModel<Content: View> {
    enum Action {
        case viewModelInit(source: Content, maxDepth: Int)
    }

    private(set) var uiModel: TreeWindowUIModel = .computingTree

    init(source: Content, maxDepth: Int) {
        handleAction(.viewModelInit(source: source, maxDepth: maxDepth))
    }

    func handleAction(_ action: Action) {
        switch action {
        case .viewModelInit(let source, let maxDepth):
            handleViewModelInit(source: source, maxDepth: maxDepth)
        }
    }
}

private extension TreeWindowViewModel {
    func handleViewModelInit(source: Content, maxDepth: Int) {
        computeTreeBreakDownOfOriginalContent(
            source: source,
            maxDepth: maxDepth
        )
    }

    func computeTreeBreakDownOfOriginalContent(source: Content, maxDepth: Int) {
        Task {
            var tree = Tree(
                node: TreeNode(
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
                mirror: Mirror(reflecting: source),
                maxDepth: maxDepth
            )

            self.uiModel = .treeComputed(
                TreeWindowUIModel.ComputedUIState(
                    treeBreakDownOfOriginalContent: tree
                )
            )
        }
    }
}
