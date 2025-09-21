import Foundation

@Observable
final class TreeNode: Sendable, Equatable {
    struct ID: Hashable {
        let rawValue: String
    }

    let type: String
    let label: String
    let value: String
    let serialNumber: Int
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String
    let childIndex: Int //If <unknown> label is used for multiple nodes, then we need to distinguish them by index. It may need a more stable differentiator.
    let childrenCount: Int

    var isParent: Bool {
        childrenCount > 0
    }

    // Everything except the `value`, because its change, does not mean that the node has changed and thus that the NodeView should be updated.
    var id: TreeNode.ID {
        ID(rawValue: "\(label)-\(type)-\(displayStyle)-\(subjectType)-\(superclassMirror)-\(mirrorDescription)-\(childIndex)-\(childrenCount)")
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
