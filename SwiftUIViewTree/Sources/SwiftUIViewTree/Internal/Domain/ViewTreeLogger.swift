
import Foundation

struct ViewTreeLogger: ViewTreeLoggerProtocol {
    @TaskLocal static var shared: ViewTreeLoggerProtocol = ViewTreeLogger()

    func logChangesOf(node: TreeNode, previousNodeValue: String) {
        print()
        print("🚨Changes detected")
        print("\"\(node.label)\":", "\"\(node.type)\"")
        print("🟥Old value:", "\"\(previousNodeValue)\"")
        print("🟩New value:", "\"\(node.value)\"") //TODO: values are sometimes very long. some better highlighting will be needed.
        findDifferences(string1: previousNodeValue, string2: node.value)
//        print("Diff: \(node.value.diff(from: previousNodeValue)) ?? "<no diff>"") //TODO: values are sometimes very long. some better highlighting will be needed.
        print()
    }
}

@MainActor
protocol ViewTreeLoggerProtocol: Sendable {
    func logChangesOf(node: TreeNode, previousNodeValue: String)
}

func findDifferences(string1: String, string2: String) {
    let arr1 = Array(string1)
    let arr2 = Array(string2)
    let maxLen = max(arr1.count, arr2.count)

    var diffStart: Int? = nil
    var diffEnd: Int? = nil

    for i in 0..<maxLen {
        let char1 = i < arr1.count ? arr1[i] : nil
        let char2 = i < arr2.count ? arr2[i] : nil

        if char1 != char2 {
            if diffStart == nil {
                diffStart = i
            }
            diffEnd = i
        }
    }

    if let start = diffStart, let end = diffEnd {
        let range1 = max(0, start)...min(end, arr1.count - 1)
        let range2 = max(0, start)...min(end, arr2.count - 1)

        let diff1 = arr1.count > start ? String(arr1[range1]) : ""
        let diff2 = arr2.count > start ? String(arr2[range2]) : ""

        print("𝚫Diff at [\(start)]: '...\(diff1)...' --> '...\(diff2)...'")
    } else {
        print("Strings are identical")
    }
}
