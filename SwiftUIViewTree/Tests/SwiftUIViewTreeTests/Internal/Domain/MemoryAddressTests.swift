
@testable import SwiftUIViewTree
import Testing

@Suite
struct MemoryAddressTests {
    @Test
    func `if neither input is memory address result should be false`() async throws {
        //GIVEN
        let string1 = "asd"
        let string2 = "asd"

        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string1, rhs: string2)

        //THEN
        #expect(result == false)
    }
}


