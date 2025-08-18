import Foundation

@Observable
final class TreeNode: Equatable { //TODO: it should depend on Node type not individual strings, but for that the diff applying should be more granular
    let type: String
    let label: String
    var value: String
//    let displayStyle: String
//    let subjectType: String
//    let superclassMirror: String
//    let mirrorDescription: String
    let isParent: Bool

    var id: String {
        "\(label.prefix(20))-\(type.prefix(20))-\(value.prefix(20))"
    }

    init(
        type: String,
        label: String,
        value: String,
//        displayStyle: String,
//        subjectType: String,
//        superclassMirror: String,
//        mirrorDescription: String,
        isParent: Bool
    ) {
        self.type = type
        self.label = label
        self.value = value
//        self.displayStyle = displayStyle
//        self.subjectType = subjectType
//        self.superclassMirror = superclassMirror
//        self.mirrorDescription = mirrorDescription
        self.isParent = isParent
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        if lhs.isParent && rhs.isParent {
            return false //that doesn't seem to be working? if a parent is updated then only the NodeView should be updated not its full children tree
        }

        return lhs.id == rhs.id
    }
}

extension TreeNode {
    static let rootNode = TreeNode(
        type: "Root node",
        label: "Root node",
        value: "Root node",
//        displayStyle: "Root node",
//        subjectType: "Root node",
//        superclassMirror: "Root node",
//        mirrorDescription: "Root node",
        isParent: true
    )
}
