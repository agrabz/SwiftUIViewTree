
@testable import SwiftUIViewTree
import Testing

@Suite
struct MemoryAddressTests {
    static let mock1 = "0x0123456789aB"
    static let mock2 = "0xF9876543210A"

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

    @Test(
        //GIVEN
        arguments: zip(
            [
                Self.mock1,
                " \(Self.mock1)",
                "\(Self.mock1) ",
                " \(Self.mock1) ",
                "something before \(Self.mock1)",
                "\(Self.mock1) something after",
                "something before \(Self.mock1) something after",
            ],
            [
                Self.mock2,
                " \(Self.mock2)",
                "\(Self.mock2) ",
                " \(Self.mock2) ",
                "something before \(Self.mock2)",
                "\(Self.mock2) something after",
                "something before \(Self.mock2) something after",
            ]
        )
    )
    func `WHEN both input is memory address AND there is diff THEN result is true`(string1: String, string2: String) async throws {
        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string1, rhs: string2)

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: [
            "\(Self.mock1)",
            " \(Self.mock1)",
            "\(Self.mock1) ",
            " \(Self.mock1) ",
            "something before \(Self.mock1)",
            "something before \(Self.mock1) something after",
            "\(Self.mock1) something after",
        ]
    )
    func `WHEN both input is memory address AND there is NO diff THEN result is false`(string: String) async throws {

        //WHEN
        let result = MemoryAddress.hasDiffInMemoryAddress(lhs: string, rhs: string)

        //THEN
        #expect(result == false)
    }
}


