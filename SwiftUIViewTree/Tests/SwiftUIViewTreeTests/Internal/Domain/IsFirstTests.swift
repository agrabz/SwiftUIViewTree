
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct IsFirstTests {
    @Test
    func stateSetting() async throws {
        //GIVEN
        let isFirst = IsFirst.shared
        //WHEN
        let initialValue = isFirst.getValue()
        let laterValue1 = isFirst.getValue()
        let laterValue2 = isFirst.getValue()
        let laterValue3 = isFirst.getValue()
        //THEN
        #expect(initialValue == true)
        #expect(laterValue1 == false)
        #expect(laterValue2 == false)
        #expect(laterValue3 == false)
    }
}
