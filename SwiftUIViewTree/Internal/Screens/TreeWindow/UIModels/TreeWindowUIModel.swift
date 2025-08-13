enum TreeWindowUIModel {
    case initialComputingTree
    case treeComputed(ComputedUIState)
    case recomputingTree(alreadyComputedState: ComputedUIState)

    struct ComputedUIState {
        let treeBreakDownOfOriginalContent: Tree
    }
}
