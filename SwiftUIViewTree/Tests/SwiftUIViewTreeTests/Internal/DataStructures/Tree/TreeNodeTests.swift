
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeNodeTests {
    @MainActor
    struct Init {
        @Test
        func getsRegistered_First() {
            //GIVEN
            let node = TreeNode.createMock()
            //WHEN
            let registeredValue = TreeNodeRegistry.shared.getRegisteredValueOfNodeWith(
                serialNumber: node.serialNumber
            )
            //THEN
            #expect(registeredValue == node.value)
        }

        @Test
        func getsRegistered_Twice_ThereIs_NO_ValueChange() {
            //GIVEN
            let node1 = TreeNode.createMock(
                type: "type",
                label: "label",
                value: "value",
                serialNumber: 42,
                childrenCount: 0
            )

            //WHEN
            _ = TreeNode.createMock(
                type: "type",
                label: "label",
                value: node1.value,
                serialNumber: 42,
                childrenCount: 0
            )

            //THEN
            #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.serialNumber == node1.serialNumber }) == false)
        }

        @Test
        func getsRegistered_Twice_There_IS_ValueChange() {
            //GIVEN
            let value1 = "value1"
            let value2 = "value2"

            let node1 = TreeNode.createMock(
                type: "type",
                label: "label",
                value: value1,
                serialNumber: 42,
                childrenCount: 0
            )

            //WHEN
            _ = TreeNode.createMock(
                type: "type",
                label: "label",
                value: value2,
                serialNumber: 42,
                childrenCount: 0
            )

            //THEN
            #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.serialNumber == node1.serialNumber }) == true)
        }
    }

    @MainActor
    struct IsParent {
        @Test
        func `true`() async throws {
            //GIVEN
            let parent = TreeNode.createMock(childrenCount: 2)
            //WHEN
            let isParent = parent.isParent
            //THEN
            #expect(isParent == true)
        }

        @Test
        func `false`() async throws {
            //GIVEN
            let parent = TreeNode.createMock(childrenCount: 0)
            //WHEN
            let isParent = parent.isParent
            //THEN
            #expect(isParent == false)
        }
    }

    @MainActor
    struct BackgroundColor {
        @Test
        func noChange() {
            //GIVEN
            let node = TreeNode.createMock()
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == LinkedColorList().colors.first)
        }

        @Test
        func isCollapsed() {
            //GIVEN
            let node = TreeNode.createMock()
            CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == UIConstants.Color.collapsedNodeBackground)
        }

        @Test
        func hasChanged() {
            //GIVEN
            let node = TreeNode.createMock()
            node.value = "new value"
            TreeNodeRegistry.shared.registerChangedNode(node)
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == LinkedColorList().colors.safeGetElement(at: 1))
            #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.id == node.id }) == false)
        }
    }
}
