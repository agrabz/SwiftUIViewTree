import Foundation

@Observable
final class TreeNode: Equatable {
    var type: String
    var label: String
    var value: String
    let displayStyle: String
    let subjectType: String
    let superclassMirror: String
    let mirrorDescription: String
    let childIndex: Int //If <unknown> label is used for multiple nodes, then we need to distinguish them by index. It may need a more stable differentiator.
    let isParent: Bool

    // Everything except the `value`, because its change, does not mean that the node has changed and thus that the NodeView should be updated.
    var id: String {
        "\(label)-\(type)-\(displayStyle)-\(subjectType)-\(superclassMirror)-\(mirrorDescription)-\(childIndex)"
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
        isParent: Bool
    ) {
        self.type = type
        self.label = label
        self.value = value
        self.displayStyle = displayStyle
        self.subjectType = subjectType
        self.superclassMirror = superclassMirror
        self.mirrorDescription = mirrorDescription
        self.childIndex = childIndex
        self.isParent = isParent
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        if lhs.value == rhs.value { // This is absolutely not clear here. Originally it was added to avoid comparing root nodes, but now it's needed otherwise many different issues can happen. E.g. the first isRecomputing will update the whole tree, but just once.
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
        isParent: true
    )
}
