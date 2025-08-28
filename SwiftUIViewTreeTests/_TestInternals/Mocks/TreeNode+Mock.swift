
@testable import SwiftUIViewTree

extension TreeNode {
    static func createMock(
        type: String = "type",
        label: String = "label",
        value: String = "value",
        displayStyle: String = "displayStyle",
        subjectType: String = "subjectType",
        superclassMirror: String = "superclassMirror",
        mirrorDescription: String = "mirrorDescription",
        childIndex: Int = 0,
        childrenCount: Int = 0
    ) -> TreeNode {
        self.init(
            type: type,
            label: label,
            value: value,
            displayStyle: displayStyle,
            subjectType: subjectType,
            superclassMirror: superclassMirror,
            mirrorDescription: mirrorDescription,
            childIndex: childIndex,
            childrenCount: childrenCount
        )
    }
}
