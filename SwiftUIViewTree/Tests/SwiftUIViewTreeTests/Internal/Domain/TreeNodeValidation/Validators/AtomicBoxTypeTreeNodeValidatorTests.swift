
@testable import SwiftUIViewTree
import Testing

@Suite
struct AtomicBoxTypeTreeNodeValidatorTests {
    @Test
    func willThrow() {
        //GIVEN
        struct AtomicBoxMockSwiftUIViewTree {}
        struct ContainerOfAtomicBoxMockSwiftUIViewTree {
            var value = AtomicBoxMockSwiftUIViewTree()
        }
        let containerOfAtomicBoxMockSwiftUIViewTree = ContainerOfAtomicBoxMockSwiftUIViewTree()

        guard let mirror = Mirror(reflecting: containerOfAtomicBoxMockSwiftUIViewTree).children.first else {
            Issue.record("Should have found a child")
            return
        }

        #expect(
            //THEN
            throws: TreeNodeValidationError.atomicBox
        ) {
            //WHEN
            try AtomicBoxTypeTreeNodeValidator().validate(mirror)
        }
    }

    @Test
    func willNotThrow() {
        //GIVEN
        struct NotAtomicBoxMockSwiftUIViewTree {}
        struct ContainerOfNotAtomicBoxMockSwiftUIViewTree {
            var value = NotAtomicBoxMockSwiftUIViewTree()
        }
        let containerOfAtomicBoxMockSwiftUIViewTree = ContainerOfNotAtomicBoxMockSwiftUIViewTree()

        guard let mirror = Mirror(reflecting: containerOfAtomicBoxMockSwiftUIViewTree).children.first else {
            Issue.record("Should have found a child")
            return
        }

        do {
            //WHEN
            try AtomicBoxTypeTreeNodeValidator().validate(mirror) //THEN
        } catch {
            Issue.record("Should not have thrown \(error)")
        }
    }

}
