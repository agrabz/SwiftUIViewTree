
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

    @Test
    func registerChangedNode() throws {
        //GIVEN
        let node = TreeNode.createMock()
        let sut = TreeNodeMemoizer()
        try sut.registerNode(serialNumber: node.serialNumber, value: node.value)

        //WHEN
        let newValue = "new value"
        node.value = newValue
        sut.registerChangedNode(node)

        //THEN
        #expect(sut.allChangedNodes.contains { $0.serialNumber == node.serialNumber })
        #expect(sut.getRegisteredValueOfNodeWith(serialNumber: node.serialNumber) == newValue)
    }

    @Test
    func isNodeChanged_True() async throws {
        //GIVEN
        let node = TreeNode.createMock()
        let sut = TreeNodeMemoizer()
        try sut.registerNode(serialNumber: node.serialNumber, value: node.value)

        let newValue = "new value"
        node.value = newValue
        sut.registerChangedNode(node)

        #expect(sut.allChangedNodes.contains { $0.serialNumber == node.serialNumber })
        #expect(sut.getRegisteredValueOfNodeWith(serialNumber: node.serialNumber) == newValue)

        //WHEN
        let isChanged = sut.isNodeChanged(serialNumber: node.serialNumber)

        //THEN
        #expect(isChanged == true)
    }

    @Test
    func isNodeChanged_False() async throws {
        //GIVEN
        let node = TreeNode.createMock()
        let sut = TreeNodeMemoizer()
        try sut.registerNode(serialNumber: node.serialNumber, value: node.value)

        #expect(sut.allChangedNodes.contains { $0.serialNumber == node.serialNumber } == false)
        #expect(sut.getRegisteredValueOfNodeWith(serialNumber: node.serialNumber) == node.value)

        //WHEN
        let isChanged = sut.isNodeChanged(serialNumber: node.serialNumber)

        //THEN
        #expect(isChanged == false)
    }

    @Test
    func removeNodeFromAllChangedNodes() throws {
        //GIVEN
        let node = TreeNode.createMock()
        let sut = TreeNodeMemoizer()
        sut.registerChangedNode(node)

        //WHEN
        sut.removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: node.serialNumber)

        //THEN
        #expect(sut.allChangedNodes.contains { $0.serialNumber == node.serialNumber } == false)
    }
}
