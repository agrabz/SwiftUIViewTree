
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeNodeMemoizerTests {
    @Test
    func registerNode_NotYetRegisteredNode() throws {
        //GIVEN
        let sut = TreeNodeMemoizer()

        //WHEN
        try sut.registerNode(serialNumber: 1, value: "value")

        //THEN
        #expect(true)
    }

    @Test
    func registerNode_AlreadyRegisteredNode() throws {
        //GIVEN
        let serialNumber = 1
        let value = "value"

        let sut = TreeNodeMemoizer()
        try sut.registerNode(serialNumber: serialNumber, value: value)

        #expect(
            //THEN
            throws: TreeNodeMemoizer.Error.nodeIsAlreadyRegistered) {
                //WHEN
                try sut.registerNode(serialNumber: serialNumber, value: value)
            }
    }

    @Test
    func getRegisteredValueOfNodeWith_ExistingRegistration() throws {
        //GIVEN
        let serialNumber = 1
        let value = "value"
        let sut = TreeNodeMemoizer()
        try sut.registerNode(serialNumber: serialNumber, value: value)

        //WHEN
        let registeredValue = sut.getRegisteredValueOfNodeWith(
            serialNumber: serialNumber
        )

        //THEN
        #expect(registeredValue == value)
    }

    @Test
    func getRegisteredValueOfNodeWith_NoRegistration() throws {
        //GIVEN
        let sut = TreeNodeMemoizer()

        //WHEN
        let registeredValue = sut.getRegisteredValueOfNodeWith(
            serialNumber: 1
        )

        //THEN
        #expect(registeredValue == nil)
    }
}
