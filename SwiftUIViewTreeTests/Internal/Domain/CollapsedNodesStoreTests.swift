
@testable import SwiftUIViewTree
import Testing

@Suite
struct CollapsedNodesStoreTests { //TODO: use a test trait instead
    @Test
    func isCollapsed_True() async throws {
        CollapsedNodesStore.$shared.withValue(.init()) {
            //GIVEN
            let mockNode = TreeNode.createMock()

            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

            //WHEN
            let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

            //THEN
            #expect(isCollapsed == true)
        }
    }

    @Test
    func isCollapsed_False() async throws {
        CollapsedNodesStore.$shared.withValue(.init()) {
            //GIVEN
            let mockNode = TreeNode.createMock()

            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)
            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

            //WHEN
            let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

            //THEN
            #expect(isCollapsed == false)
        }
    }

    @Test
    func toggleCollapse_FromExpanded_ToCollapsed() async throws {
        CollapsedNodesStore.$shared.withValue(.init()) {
            //GIVEN
            let mockNode = TreeNode.createMock()

            let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
            #expect(isCollapsed == false)

            //WHEN
            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

            //THEN
            let isCollapsedAfterToggle = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
            #expect(isCollapsedAfterToggle == true)
        }
    }

    @Test
    func toggleCollapse_FromCollapsed_ToExpanded() async throws {
        CollapsedNodesStore.$shared.withValue(.init()) {
            //GIVEN
            let mockNode = TreeNode.createMock()

            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

            let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
            #expect(isCollapsed == true)

            //WHEN
            CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

            //THEN
            let isCollapsedAfterToggle = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
            #expect(isCollapsedAfterToggle == false)
        }
    }
}
