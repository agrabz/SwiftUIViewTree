
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeNodeTests {
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
            TreeNodeMemoizer.shared.registerChangedNode(node)
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == LinkedColorList().colors.safeGetElement(at: 1))
            #expect(TreeNodeMemoizer.shared.allChangedNodes.contains(where: { $0.id == node.id }) == false)
        }
    }
}
