
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct SwiftUIViewTreeConfigurationTests {
    @Test(.viewTree())
    func `WHEN default THEN isMemoryAddressDiffingEnabled is false`() async throws {
        //GIVEN
        let configuration = Configuration.shared

        //WHEN
        let result = configuration.isMemoryAddressDiffingEnabled

        //THEN
        #expect(result == false)
    }

    @Test(.viewTree())
    func `WHEN applySettings is called AND contains .enableMemoryAddressDiffing THEN isMemoryAddressDiffingEnabled is true`() async throws {
        //GIVEN
        let configuration = Configuration.shared

        //WHEN
        configuration.applySettings([.enableMemoryAddressDiffing])

        //THEN
        #expect(configuration.isMemoryAddressDiffingEnabled == true)
    }
}


