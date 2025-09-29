
@testable import SwiftUIViewTree
import Testing

@Suite(.viewTree())
struct LinkedColorListTests {
    @Test
    func getNextColor_First() async throws {
        //GIVEN
        var list = LinkedColorList()

        //WHEN
        let result = list.getNextColor()

        //THEN
        #expect(result == list.colors.safeGetElement(at: 1))
    }

    @Test
    func getNextColor_Third() async throws {
        //GIVEN
        var list = LinkedColorList()

        //WHEN
        _ = list.getNextColor()
        _ = list.getNextColor()
        let result3 = list.getNextColor()

        //THEN
        #expect(result3 == list.colors.safeGetElement(at: 3))
    }

    @Test
    func getNextColor_BackToFirst() async throws {
        //GIVEN
        var list = LinkedColorList()

        //WHEN
        for _ in 1...list.colors.count - 1 {
            _ = list.getNextColor()
        }
        let result = list.getNextColor()

        //THEN
        #expect(result == list.colors.safeGetElement(at: 0))
    }
}
