
import SwiftUI
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeContainerTests {
    @Test
    func initialState() {
        //GIVEN
        var treeContainer: TreeContainer

        //WHEN
        treeContainer = TreeContainer()

        //THEN
        guard case .computingTree = treeContainer.uiState else {
            Issue.record("Unexpected initial state \(treeContainer.uiState)")
            return
        }
        #expect(treeContainer.isRecomputing == false)
    }

    @Test
    func computeViewTree_FirstTime() async {
        //GIVEN
        let treeContainer = TreeContainer()

        let originalView = Text("Hello, World!")
        let modifiedView = Text("Hello, World!").bold()

        //WHEN
        treeContainer.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        #expect(treeContainer.isRecomputing == false)
        try? await Task.sleep(for: .seconds(TreeContainer.waitTimeInSeconds + 0.5))

        //THEN
        #expect(treeContainer.isRecomputing == false)
        guard case .treeComputed(let computedUIState) = treeContainer.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeContainer.uiState)")
            return
        }

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.parentNode.id == .init(
                rawValue: TreeNode.rootNode.serialNumber
            )
        )

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.children
                .safeGetElement(at: 0)?.parentNode.id == .init(
                    rawValue: RootNodeType.originalView.serialNumber
                )
        )

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.children
                .safeGetElement(at: 1)?.parentNode.id == .init(
                    rawValue: RootNodeType.modifiedView.serialNumber
                )
        )
    }

    @Test
    func computeViewTree_NonFirstTime() async {
        //GIVEN
        let treeContainer = TreeContainer()

        let originalView = Text("Hello, World!")
        let modifiedView = Text("Hello, World!").bold()

        treeContainer.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        #expect(treeContainer.isRecomputing == false)
        try? await Task.sleep(for: .seconds(TreeContainer.waitTimeInSeconds + 0.5))

        #expect(treeContainer.isRecomputing == false)
        guard case .treeComputed = treeContainer.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeContainer.uiState)")
            return
        }

        //WHEN
        treeContainer.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        //THEN
        try? await Task.sleep(for: .seconds(0.2)) // mini-delay is needed because computeViewTree's logic is running in a Task
        #expect(treeContainer.isRecomputing == true) // if the delay is turned off this expectation might fail, and in that case this test doesn't make sense anymore

        try? await Task.sleep(for: .seconds(TreeContainer.waitTimeInSeconds + 0.5))
        #expect(treeContainer.isRecomputing == false)

        guard case .treeComputed(let computedUIState) = treeContainer.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeContainer.uiState)")
            return
        }

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.parentNode.id == .init(
                rawValue: TreeNode.rootNode.serialNumber
            )
        )

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.children
                .safeGetElement(at: 0)?.parentNode.id == .init(
                    rawValue: RootNodeType.originalView.serialNumber
                )
        )

        #expect(
            computedUIState.treeBreakDownOfOriginalContent.children
                .safeGetElement(at: 1)?.parentNode.id == .init(
                    rawValue: RootNodeType.modifiedView.serialNumber
                )
        )
    }
}
