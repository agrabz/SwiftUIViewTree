
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct CollapsedNodesStoreTests {
    @Test
    func isCollapsed_True() async throws {
        //GIVEN
        let mockNode = TreeNode.createMock()

        CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

        //WHEN
        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

        //THEN
        #expect(isCollapsed == true)
    }

    @Test
    func isCollapsed_False() async throws {
        //GIVEN
        let mockNode = TreeNode.createMock()

        CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)
        CollapsedNodesStore.shared.toggleCollapse(nodeID: mockNode.id)

        //WHEN
        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)

        //THEN
        #expect(isCollapsed == false)
    }

    @Test
    func toggleCollapse_FromExpanded_ToCollapsed() async throws {
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

    @Test
    func toggleCollapse_FromCollapsed_ToExpanded() async throws {
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

    @Test
    func `collapse from expanded to collapsed`() {
        //GIVEN
        let mockNode = TreeNode.createMock()

        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsed == false)

        //WHEN
        CollapsedNodesStore.shared.collapse(nodeID: mockNode.id)

        //THEN
        let isCollapsedAfterCollapse = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsedAfterCollapse == true)
    }

    @Test
    func `collapse from collapsed to collapsed`() {
        //GIVEN
        let mockNode = TreeNode.createMock()

        let isCollapsed = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsed == false)

        CollapsedNodesStore.shared.collapse(nodeID: mockNode.id)

        let isCollapsedAfterToggle = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsedAfterToggle == true)


        //WHEN
        CollapsedNodesStore.shared.collapse(nodeID: mockNode.id)

        //THEN
        let isCollapsedAfterSecondCollapse = CollapsedNodesStore.shared.isCollapsed(nodeID: mockNode.id)
        #expect(isCollapsedAfterSecondCollapse == true)

    }
}
