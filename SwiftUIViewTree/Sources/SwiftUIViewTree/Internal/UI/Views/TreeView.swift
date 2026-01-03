
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

    var body: some View {
        VStack {
            ParentNodeView(
                parentNode: $tree.parentNode
            )

            ForEach(self.treeLevels(), id: \.self) { treeLevels in  //TODO: better names?
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

    func treeLevels() -> [[Tree]] { //TODO: review vibe
        var result: [[Tree]] = []
        var currentLevel: [Tree] = [tree]

        while !currentLevel.isEmpty {
            result.append(currentLevel)

            var nextLevel: [Tree] = []

            for node in currentLevel {
                if collapsedNodesStore.isCollapsed(nodeID: node.parentNode.id) {
                    continue   // ← PRUNE ENTIRE SUBTREE
                }

                nextLevel.append(contentsOf: node.children)
            }

            currentLevel = nextLevel
        }

        return result
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
