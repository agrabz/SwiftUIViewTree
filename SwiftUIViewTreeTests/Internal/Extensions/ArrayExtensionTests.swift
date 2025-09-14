
@testable import SwiftUIViewTree
import Testing

@Suite
struct ArrayExtensionTests {
    @Test(
        arguments: [
            0,
            1,
            2,
            3,
            4,
        ]
    )
    func nonNil(safeIndex: Int) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetElement(at: safeIndex)

        //THEN
        #expect(result != nil)
    }

    @Test(
        arguments: [
            -1,
            5,
            6,
        ]
    )
    func isNil(unsafeIndex: Int) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetElement(at: unsafeIndex)

        //THEN
        #expect(result == nil)
    }
}

