
@testable import SwiftUIViewTree
import Testing

@Suite
struct AtomicBufferTypeTreeNodeValidatorTests {
    @Test
    func willThrow() {
        //GIVEN
        struct AtomicBufferMockSwiftUIViewTree {}
        struct ContainerOfAtomicBufferMockSwiftUIViewTree {
            var value = AtomicBufferMockSwiftUIViewTree()
        }
        let containerOfAtomicBufferMockSwiftUIViewTree = ContainerOfAtomicBufferMockSwiftUIViewTree()

        guard let mirror = Mirror(reflecting: containerOfAtomicBufferMockSwiftUIViewTree).children.first else {
            Issue.record("Should have found a child")
            return
        }

        #expect(
            //THEN
            throws: TreeNodeValidationError.atomicBuffer
        ) {
            //WHEN
            try AtomicBufferTypeTreeNodeValidator().validate(mirror)
        }
    }

    @Test
    func willNotThrow() {
        //GIVEN
        struct NotAtomicBufferMockSwiftUIViewTree {}
        struct ContainerOfNotAtomicBufferMockSwiftUIViewTree {
            var value = NotAtomicBufferMockSwiftUIViewTree()
        }
        let containerOfNotAtomicBufferMockSwiftUIViewTree = ContainerOfNotAtomicBufferMockSwiftUIViewTree()

        guard let mirror = Mirror(reflecting: containerOfNotAtomicBufferMockSwiftUIViewTree).children.first else {
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


