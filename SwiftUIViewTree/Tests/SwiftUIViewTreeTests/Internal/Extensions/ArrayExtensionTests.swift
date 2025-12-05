
@testable import SwiftUIViewTree
import Testing

@Suite(.viewTree())
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

    @Test(
        arguments: [
            0...0,
            0...1,
            0...4,
            2...3,
            4...4
        ]
    )
    func subSequence_nonNil(validRange: ClosedRange<Int>) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetSubSequence(in: validRange)

        //THEN
        #expect(result != nil)
        if let result {
            let expected = Array(array[validRange])
            #expect(Array(result) == expected)
        }
    }

    @Test(
        arguments: [
            (-1)...0,
            0...5,
            5...5,
            (-2)...(-1),
            3...6
        ]
    )
    func subSequence_isNil(invalidRange: ClosedRange<Int>) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetSubSequence(in: invalidRange)

        //THEN
        #expect(result == nil)
    }

    @Test(
        arguments: [
            0...0,
            0...1,
            1...3,
            0...4,
            4...4
        ]
    )
    func subSequenceOrEmpty_returnsSubSequence(validRange: ClosedRange<Int>) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetSubSequenceOrEmpty(in: validRange)

        //THEN
        let expected = Array(array[validRange])
        #expect(Array(result) == expected)
    }

    @Test(
        arguments: [
            (-1)...0,
            0...5,
            5...5,
            (-3)...(-1),
            6...7
        ]
    )
    func subSequenceOrEmpty_returnsEmpty(invalidRange: ClosedRange<Int>) async throws {
        //GIVEN
        let array = [1, 2, 3, 4, 5]

        //WHEN
        let result = array.safeGetSubSequenceOrEmpty(in: invalidRange)

        //THEN
        #expect(Array(result).isEmpty)
    }
}

