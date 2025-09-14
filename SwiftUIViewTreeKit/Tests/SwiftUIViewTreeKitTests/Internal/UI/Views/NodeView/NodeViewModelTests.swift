
@testable import SwiftUIViewTreeKit
import Testing

@Suite
struct NodeViewModelTests {
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

    @Test(.viewTree())
    func collapsedIsGray() async throws {
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
    func colorAfter_FirstNoChange_ThenStillNoChange() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock = TreeNode.createMock()

        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)
        #expect(firstColor == nodeViewModel.colors.first)
        let colorAfterNoChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)
        #expect(colorAfterNoChange == firstColor)

        //WHEN
        let colorAfterStillNoChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock)

        //THEN
        #expect(colorAfterStillNoChange == colorAfterNoChange)
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

    @Test
    func colorAfter_FirstValueChange_ThenAgainValueChange() async throws {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock1 = TreeNode.createMock()

        let firstColor = nodeViewModel.getBackgroundColorAndLogChanges(node: mock1)
        #expect(firstColor == nodeViewModel.colors.first)

        let mock2 = TreeNode.createMock(value: "new value1")
        let colorAfter_First_ValueChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock2)
        #expect(colorAfter_First_ValueChange == nodeViewModel.colors.safeGetElement(at: 1))
        #expect(colorAfter_First_ValueChange != firstColor)

        //WHEN
        let mock3 = TreeNode.createMock(value: "new value2")
        let colorAfter_Second_ValueChange = nodeViewModel.getBackgroundColorAndLogChanges(node: mock3)

        //THEN
        #expect(colorAfter_Second_ValueChange != colorAfter_First_ValueChange)
        #expect(colorAfter_Second_ValueChange != firstColor)
        #expect(colorAfter_Second_ValueChange == nodeViewModel.colors.safeGetElement(at: 2))
    }

    @Test(.viewTree(viewTreeLogger: SpyViewTreeLogger()))
    func printAfterValueChange() {
        //GIVEN
        let nodeViewModel = NodeViewModel()
        let mock1 = TreeNode.createMock()

        _ = nodeViewModel.getBackgroundColorAndLogChanges(node: mock1)

        //WHEN
        let mock2 = TreeNode.createMock(value: "new value")
        _ = nodeViewModel.getBackgroundColorAndLogChanges(node: mock2)

        //THEN
        guard let spyViewTreeLogger = ViewTreeLogger.shared as? SpyViewTreeLogger else {
            Issue.record("Unexpected non-spy: \(ViewTreeLogger.shared)")
            return
        }
        #expect(spyViewTreeLogger.hasBeenCalled)
    }
}
