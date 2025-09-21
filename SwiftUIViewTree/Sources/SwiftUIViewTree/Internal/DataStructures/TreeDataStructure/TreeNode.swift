import Foundation
import SwiftUI

struct LinkedColorList {
    private let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
    ]
    private var currentIndex = 0

    mutating func getNextColor() -> Color {
        guard let color = colors.safeGetElement(at: currentIndex % colors.count) else {
            print("no new color")
            return .purple.opacity(0.8)
        }
        print("yes new color")
        currentIndex += 1
        return color
    }
}

struct LinkedColor {
    let color: Color
    var _next: [LinkedColor]
    var next: LinkedColor {
        if _next.isEmpty {
            return self
        }
        return _next[0]
    }
}

@MainActor
@Observable
final class TreeNode: @unchecked Sendable, @MainActor Equatable {
    struct ID: Hashable {
        let rawValue: Int
    }

    @ObservationIgnored
    private var availableColors = LinkedColorList()

    let type: String
    let label: String
    var value: String //TODO: var
    let serialNumber: Int
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String
    let childIndex: Int //If <unknown> label is used for multiple nodes, then we need to distinguish them by index. It may need a more stable differentiator.
    let childrenCount: Int

    @ObservationIgnored
    private var oldValue: String {
        TreeNodeMemoizer.shared.getValueOfNodeWith(serialNumber: serialNumber) ?? ""
    }
    @ObservationIgnored
    private var oldBackgroundColor: Color = .purple.opacity(0.8)
    var backgroundColor: Color {
        guard value != oldValue else {
//            print("   __same: \(label) \(type) -->\(value)")
            return oldBackgroundColor
        }
        print("____COLORNEW: \(label) \(type) -->\(value)")

        oldBackgroundColor = availableColors.getNextColor()
        return oldBackgroundColor
    }

    var isParent: Bool {
        childrenCount > 0
    }

    var id: TreeNode.ID {
        ID(rawValue: serialNumber)
    }

    init(
        type: String,
        label: String,
        value: String,
        displayStyle: String,
        subjectType: String,
        superclassMirror: String,
        mirrorDescription: String,
        childIndex: Int,
        childrenCount: Int,
        serialNumber: Int
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.displayStyle = displayStyle
        self.subjectType = subjectType
        self.superclassMirror = superclassMirror
        self.mirrorDescription = mirrorDescription
        self.childIndex = childIndex
        self.childrenCount = childrenCount
        self.serialNumber = serialNumber

        print(serialNumber)

        TreeNodeMemoizer.shared.registerNode(serialNumber: serialNumber, value: value)

        guard value != oldValue else {
//            print("   __not changed: \(label) \(type) -->\(value)")
            return
        }
        print("!!IS CHANGED: \(label) \(type) -->\(value)")
        TreeNodeMemoizer.shared.registerChangedNode(self)

    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        if lhs.value == rhs.value { // Without this check the initial isRecomputing would result in a complete tree color change. This is not clear. Probaly something with the Equatable conformances throughout the project.
            return false
        }
        return lhs.id == rhs.id
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: "Root node",
        label: "Root node",
        value: "Root node",
        displayStyle: "Root node",
        subjectType: "Root node",
        superclassMirror: "Root node",
        mirrorDescription: "Root node",
        childIndex: 0,
        childrenCount: 0, //is actually 2 (modifiedView+originalView) but collapsing the root node does not make sense
        serialNumber: -1
    )
}

@MainActor
final class TreeNodeMemoizer {
    static let shared = TreeNodeMemoizer()

    private var memo: [Int: String] = [:]
    private var allChanges = [TreeNode]()

    func registerNode(serialNumber: Int, value: String) {
        if memo[serialNumber] == nil {
            memo[serialNumber] = value
        }
    }

    func getValueOfNodeWith(serialNumber: Int) -> String? {
        memo[serialNumber]
    }


    //TODO: ehh
    func registerChangedNode(_ node: TreeNode) {
        allChanges.append(node)
    }

    //TODO: ehh
    func getAllChanges() -> [TreeNode] {
        allChanges
    }
}
