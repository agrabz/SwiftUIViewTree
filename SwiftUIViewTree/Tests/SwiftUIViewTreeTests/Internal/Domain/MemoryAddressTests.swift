
@testable import SwiftUIViewTree
import Testing

@Suite
struct MemoryAddressTests {
    @Test
    func `WHEN neither input is memory address THEN result should be false`() async throws {
        //GIVEN
        let string1 = "asd"
        let string2 = "asd"

        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string1, rhs: string2)

        //THEN
        #expect(result == false)
    }

    @Test
    func `WHEN both input is memory address AND there is diff THEN result is true`() async throws {
        //GIVEN
        let string1 = "0x0123456789aB"
        let string2 = "0xF9876543210A"

        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string1, rhs: string2)

        //THEN
        #expect(result == true)
    }

    @Test
    func `WHEN both input is memory address AND there is NO diff THEN result is false`() async throws {
        //GIVEN
        let string1 = "0x0123456789aB"
        let string2 = "0x0123456789aB"

        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string1, rhs: string2)

        //THEN
        #expect(result == true)
    }
}


