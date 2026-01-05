
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct NodeSerialNumberCounterTests {
    @Test
    func getCounter_Once() async throws {
        //GIVEN
        let counter = NodeSerialNumberCounter()
        //WHEN
        let result = await counter.counter
        //THEN
        #expect(result == 1)
    }

    @Test
    func getCounter_MultipleTimes() async throws {
        //GIVEN
        let counter = NodeSerialNumberCounter()
        //WHEN
        var testCounter = 0
        //THEN
        for _ in 0..<10 {
            let result = await counter.counter
            #expect(result == testCounter + 1)
            testCounter += 1
        }
    }

    @Test
    func reset() async throws {
        //GIVEN
        let counter = NodeSerialNumberCounter()
        var testCounter = 0
        for _ in 0..<10 {
            let result = await counter.counter
            #expect(result == testCounter + 1)
            testCounter += 1
        }
        //WHEN
        await counter.reset()
        //THEN
        let resultAfterReset = await counter.counter
        #expect(resultAfterReset == 1)
    }
}
