//
//  TreeWindowScreen.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct TreeWindowScreen<Content: View>: View {
    @State var viewModel: TreeWindowViewModel<Content>
    let originalContent: Content

    var body: some View {
        GeometryReader { geometry in
            HStack {
                originalContent
                    .frame(width: geometry.size.width * 1/4)

                NavigationStack {
                    switch viewModel.uiModel {
                        case .computingTree:
                            ViewTreeTraversalProgressView()
                        case .treeComputed(let computedUIState):
                            TreeView(tree: computedUIState.treeBreakDownOfOriginalContent)
                    }
                }
                .frame(width: geometry.size.width * 3/4)
            }
        }
    }
}
