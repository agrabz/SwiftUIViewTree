//
//  TreeWindowUIModel.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

enum TreeWindowUIModel {
    case computingTree
    case treeComputed(ComputedUIState)

    struct ComputedUIState {
        let treeBreakDownOfOriginalContent: Tree
    }
}
