
import Foundation
@testable import SwiftUIViewTree

extension TreeNode {
    static func createMock(
        type: String = "type",
        label: String = UUID().uuidString, // To make sure that mocks are different
        value: String = "value",
        serialNumber: Int = Int.random(in: 0...1_000_000),
        registerChanges: Bool = true
    ) -> TreeNode {
        self.init(
            type: type,
            label: label,
            value: value,
            serialNumber: serialNumber,
            registerChanges: registerChanges
        )
    }
}
