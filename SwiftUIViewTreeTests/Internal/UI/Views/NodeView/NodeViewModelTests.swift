
@testable import SwiftUIViewTree
import Testing

@Suite
struct NodeViewModelTests {

    /// To test:
    /// initial color
    /// collapsing and expanding nodes
    /// new color when different value
    /// no color change when same value

    @Test
    func initialColor() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock = TreeNode.createMock()

        //WHEN
        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)

        //THEN
        #expect(firstColor == nodeViewModel.colors.first)
    }

    @Test
    func collapsedIsGray() async throws {
        CollapsedNodesStore.$shared.withValue(.init()) {
            //GIVEN
            let nodeViewModel = NodeViewModel()
            let mock = TreeNode.createMock()

            let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)
            #expect(firstColor == nodeViewModel.colors.first)

            //WHEN
            CollapsedNodesStore.shared.toggleCollapse(nodeID: mock.id)

            let colorAfterCollapsing = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)

            //THEN
            #expect(colorAfterCollapsing == UIConstants.Color.collapsedNodeBackground)
        }
    }

    @Test
    func colorAfterNoChange() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock = TreeNode.createMock()

        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)
        #expect(firstColor == nodeViewModel.colors.first)

        //WHEN
        let colorAfterNoChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)

        //THEN
        #expect(colorAfterNoChange == firstColor)
    }

    @Test
    func colorAfterValueChange() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock1 = TreeNode.createMock()

        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock1)
        #expect(firstColor == nodeViewModel.colors.first)

        //WHEN
        let mock2 = TreeNode.createMock(value: "new value")
        let colorAfterValueChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock2)

        //THEN
        #expect(colorAfterValueChange != firstColor)
    }

    @Test
    func colorAfter_FirstNoChange_ThenValueChange() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock1 = TreeNode.createMock()

        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock1)
        #expect(firstColor == nodeViewModel.colors.first)
        let colorAfterNoChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock1)
        #expect(colorAfterNoChange == firstColor)

        //WHEN
        let mock2 = TreeNode.createMock(value: "new value")
        let colorAfterValueChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock2)

        //THEN
        #expect(colorAfterValueChange != colorAfterNoChange)
    }
}
