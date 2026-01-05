
import SwiftUI

struct ColumnedGrid<Element, GridCell>: View where GridCell: View {
    let source: [Element]
    let numberOfColumns: Int
    let gridCell: (_ element: Element) -> GridCell

    var body: some View {
        Grid {
            ForEach(Array(stride(from: 0, to: self.source.count, by: self.numberOfColumns)), id: \.self) { rowIndex in
                GridRow {
                    ForEach(0..<self.numberOfColumns, id: \.self) { columnIndex in
                        if let element = self.source.safeGetElement(at: rowIndex + columnIndex) {
                            self.gridCell(element)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
