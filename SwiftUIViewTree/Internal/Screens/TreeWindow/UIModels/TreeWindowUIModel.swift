enum TreeWindowUIModel {
    case computingTree
    case treeComputed(ComputedUIState)

    struct ComputedUIState {
        let treeBreakDownOfOriginalContent: Tree
    }
}
