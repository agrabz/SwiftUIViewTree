
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct CollapsedNodesStoreTests {
    @Test
    func isCollapsed_True() async throws {
        //GIVEN
        let collapsedNodesStore = CollapsedNodesStore()
        let mockNode = TreeNode.createMock()

        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)

        //WHEN
        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

        //THEN
        #expect(isCollapsed == true)
    }

    @Test
    func isCollapsed_False() async throws {
        //GIVEN
        let collapsedNodesStore = CollapsedNodesStore()
        let mockNode = TreeNode.createMock()

        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)
        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)

        //WHEN
        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

        //THEN
        #expect(isCollapsed == false)
    }

    @Test
    func toggleCollapse_FromExpanded_ToCollapsed() async throws {
        //GIVEN
        let collapsedNodesStore = CollapsedNodesStore()
        let mockNode = TreeNode.createMock()

        let isCollapsed = collapsedNodesStore.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsed == false)

        //WHEN
        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)

        //THEN
        let isCollapsedAfterToggle = collapsedNodesStore.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsedAfterToggle == true)
    }

    @Test
    func toggleCollapse_FromCollapsed_ToExpanded() async throws {
        //GIVEN
        let collapsedNodesStore = CollapsedNodesStore()
        let mockNode = TreeNode.createMock()

        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)

        let isCollapsed = collapsedNodesStore.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsed == true)

        //WHEN
        collapsedNodesStore.toggleCollapse(nodeID: mockNode.id)

        //THEN
        let isCollapsedAfterToggle = collapsedNodesStore.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsedAfterToggle == false)
    }
}
