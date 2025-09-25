import Foundation
import SwiftUI

struct LinkedColorList {
    private let colors: [Color] = [
        .purple.opacity(0.8),
        .red.opacity(0.8),
        .yellow.opacity(0.8),
        .green.opacity(0.8),
    ]
    private var currentIndex = -1

    mutating func getNextColor() -> Color {
        currentIndex += 1
        guard let color = colors.safeGetElement(at: currentIndex % colors.count) else {
            return .purple.opacity(0.8)
        }
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
    var value: String
    let serialNumber: Int
    let childrenCount: Int

    @ObservationIgnored
    private var oldValue: String {
        TreeNodeMemoizer.shared.getRegisteredValueOfNodeWith(serialNumber: serialNumber) ?? ""
    }
    @ObservationIgnored
    private var oldBackgroundColor: Color = .clear
    var backgroundColor: Color {
        if label == "_value" {
            print("asdsa")
        }

        if CollapsedNodesStore.shared.isCollapsed(nodeID: id) {
            return UIConstants.Color.collapsedNodeBackground
        }

        guard TreeNodeMemoizer.shared.isNodeChanged(serialNumber: self.serialNumber) else {
            if oldBackgroundColor == .clear {
                oldBackgroundColor = availableColors.getNextColor()
            }
            return oldBackgroundColor
        }

        oldBackgroundColor = availableColors.getNextColor()
        TreeNodeMemoizer.shared.clearChangesOfNodeWith(serialNumber: serialNumber)
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
        serialNumber: Int,
        childrenCount: Int
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.serialNumber = serialNumber
        self.childrenCount = childrenCount

        print(serialNumber)

        if label == "_value" {
            print(label)
        }

        TreeNodeMemoizer.shared.registerNode(serialNumber: serialNumber, value: value)

        if value != oldValue {
            TreeNodeMemoizer.shared.registerChangedNode(self)
        }
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: "Root node",
        label: "Root node",
        value: "Root node",
        serialNumber: -1,
        childrenCount: 0 //is actually 2 (modifiedView+originalView) but collapsing the root node does not make sense
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

    func getRegisteredValueOfNodeWith(serialNumber: Int) -> String? {
        memo[serialNumber]
    }


    //TODO: ehh
    func registerChangedNode(_ node: TreeNode) {
        allChanges.append(node)
        memo[node.serialNumber] = node.value
    }

    //TODO: ehh
    func getAllChanges() -> [TreeNode] {
        allChanges
    }

    func isNodeChanged(serialNumber: Int) -> Bool {
        allChanges.contains { $0.serialNumber == serialNumber }
    }

    func clearChangesOfNodeWith(serialNumber: Int) {
        allChanges.removeAll { $0.serialNumber == serialNumber }
    }
//        for change in allChanges {
//            memo[change.serialNumber] = change.value
//        }
//        allChanges.removeAll()
//    }
}
