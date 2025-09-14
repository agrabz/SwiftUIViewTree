enum TreeWindowUIModel {
    case computingTree
    case treeComputed(ComputedUIState)

    struct ComputedUIState {
        var treeBreakDownOfOriginalContent: Tree
    }
}
