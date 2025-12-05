
import Foundation

struct ViewTreeLogger: ViewTreeLoggerProtocol {
    @TaskLocal static var shared: ViewTreeLoggerProtocol = ViewTreeLogger()

    func logChangesOf(node: TreeNode, previousNodeValue: String) {
        print()
        print("🚨Changes detected in \"\(node.label)\":", "\"\(node.type)\"")
        print("🟥Old value:", "\"\(previousNodeValue)\"")
        print("🟩New value:", "\"\(node.value)\"")
        printDiffOf(lhs: previousNodeValue, rhs: node.value)
        print()
    }
}

private extension ViewTreeLogger {
    func printDiffOf(lhs: String, rhs: String) {
        let lhsStringElementArray = Array(lhs)
        let rhsStringElementArray = Array(rhs)
        let maxLength = max(lhsStringElementArray.count, rhsStringElementArray.count)

        var diffStart: Int? = nil
        var diffEnd: Int? = nil

        for index in 0..<maxLength { //TODO: this finds all the diff but remembers to the last one only, would be nice to diff them all
            let lhsChar = index < lhsStringElementArray.count ? lhsStringElementArray.safeGetElement(at: index) : nil
            let rhsChar = index < rhsStringElementArray.count ? rhsStringElementArray.safeGetElement(at: index) : nil

            if lhsChar != rhsChar {
                if diffStart == nil {
                    diffStart = index
                }
                diffEnd = index
            }
        }

        if let diffStart, let diffEnd {
            let lhsDiffRange = max(0, diffStart)...min(diffEnd, lhsStringElementArray.count - 1)
            let rhsDiffRange = max(0, diffStart)...min(diffEnd, rhsStringElementArray.count - 1)

            let lhsDiff = lhsStringElementArray.count > diffStart ? String(lhsStringElementArray.safeGetSubSequenceOrEmpty(in: lhsDiffRange)) : ""
            let rhsDiff = rhsStringElementArray.count > diffStart ? String(rhsStringElementArray.safeGetSubSequenceOrEmpty(in: rhsDiffRange)) : ""

            print("🔺Diff at [\(diffStart)]: '...\(lhsDiff)...' --> '...\(rhsDiff)...'")
        } else {
            print("Strings are identical")
        }
    }
}

@MainActor
protocol ViewTreeLoggerProtocol: Sendable {
    func logChangesOf(node: TreeNode, previousNodeValue: String)
}
