
import SwiftUI

extension Array {
    func getElementAt(index: Int) -> Element? {
        return (index < self.endIndex) ? self[index] : nil
    }
}

struct CustomGridLayout<Element, GridCell>: View where GridCell: View {

    private var array: [Element]
    private var numberOfColumns: Int
    private var gridCell: (_ element: Element) -> GridCell

    init(_ array: [Element], numberOfColumns: Int, @ViewBuilder gridCell: @escaping (_ element: Element) -> GridCell) {
        self.array = array
        self.numberOfColumns = numberOfColumns
        self.gridCell = gridCell
    }

    var body: some View {
        Grid {
            ForEach(Array(stride(from: 0, to: self.array.count, by: self.numberOfColumns)), id: \.self) { index in
                GridRow {
                    ForEach(0..<self.numberOfColumns, id: \.self) { j in
                        if let element = self.array.getElementAt(index: index + j) {
                            self.gridCell(element)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TreeView: View {
    @State private var collapsedNodesStore = CollapsedNodesStore.shared

    @Binding var tree: Tree
    var firstTree: Tree {
        tree.children.first!
    }
    var secondTree: Tree {
        tree.children[1]
    }

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            HStack(alignment: .top) {
                VStack {

                    ParentNodeView(
                        parentNode: $tree.children[0].parentNode
                    )

                    ForEach(getAllTreeLevels(of: firstTree), id: \.self) { treeLevels in
                        HStack(alignment: .top) {
                            ForEach(treeLevels, id: \.parentNode.id) { tree in
                                if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                                    getViewForTreeChildren(actualTree: tree)
                                }
                            }
                        }
                        .fixedSize()
                    }
                }

                VStack {

                    ParentNodeView(
                        parentNode: $tree.children[1].parentNode
                    )

                    ForEach(getAllTreeLevels(of: secondTree), id: \.self) { treeLevels in
                        HStack(alignment: .top) {
                            ForEach(treeLevels, id: \.parentNode.id) { tree in
                                if collapsedNodesStore.isCollapsed(nodeID: tree.parentNode.id) == false {
                                    getViewForTreeChildren(actualTree: tree)
                                }
                            }
                        }
                        .fixedSize()
                    }
                }
            }
        }
    }

    func getAllTreeLevels(of treer: Tree) -> [[Tree]] { //TODO: placement?
        var allTreeLevels = [[Tree]]()
        var currentLevelOfTrees = [treer]

        while currentLevelOfTrees.isNotEmpty {
            allTreeLevels.append(currentLevelOfTrees)

            var nextLevelOfTrees = [Tree]()

            for currentLevelTree in currentLevelOfTrees {
                if collapsedNodesStore.isCollapsed(nodeID: currentLevelTree.parentNode.id) {
                    continue
                }

                nextLevelOfTrees.append(contentsOf: currentLevelTree.children)
            }

            currentLevelOfTrees = nextLevelOfTrees
        }

        return allTreeLevels
    }

    func getViewForTreeChildren(actualTree: Tree) -> some View { //TODO: better names
        CustomGridLayout(actualTree.children, numberOfColumns: 4) { actualTree in
            ParentNodeView(
                parentNode: .init(
                    get: {
                        actualTree.parentNode
                    },
                    set: { newValue in
                        if let index = actualTree.children.firstIndex(
                            where: { actualTreeCandidate in
                                actualTreeCandidate.parentNode.id == newValue.id
                            }
                        ) {
                            actualTree.children[index].parentNode = newValue
                        }
                    }
                )
            )
        }
    }
}
