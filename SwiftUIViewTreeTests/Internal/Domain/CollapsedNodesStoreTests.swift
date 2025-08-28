
@testable import SwiftUIViewTree
import Testing

@Suite
struct CollapsedNodesStoreTests {
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
}
