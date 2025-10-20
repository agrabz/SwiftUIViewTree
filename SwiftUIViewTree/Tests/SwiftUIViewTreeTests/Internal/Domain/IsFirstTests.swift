
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct IsFirstTests {
    @Test
    func stateSetting() async throws {
        //GIVEN
        let isFirst = IsFirst.shared.isFirst
        //WHEN
        IsFirst.shared.isFirst.toggle()
        //THEN
        #expect(isFirst != IsFirst.shared.isFirst)
    }
}
