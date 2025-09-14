
import Foundation
@testable import SwiftUIViewTreeKit

extension TreeNode {
    static func createMock(
        type: String = "type",
        label: String = UUID().uuidString, // To make sure that mocks are different
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
