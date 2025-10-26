
@testable import SwiftUIViewTree
import Testing

@Suite
struct LocationLabelTreeNodeValidatorTests {
    @Test
    func willThrow() {
        //GIVEN
        let sut = Mirror.Child(label: TreeNodeValidationError.location.rawValue, value: "whatever")

        #expect(
            //THEN
            throws: TreeNodeValidationError.location
        ) {
            //WHEN
            try LocationLabelTreeNodeValidator().validate(sut)
        }
    }
    @Test
    func willNotThrow() {
        //GIVEN
        let sut = Mirror.Child(label: "not location", value: "whatever")

        //WHEN
        do {
            try LocationLabelTreeNodeValidator().validate(sut)
        } catch {
            Issue.record("Should have not throw: \(error)")
        }
    }
}

