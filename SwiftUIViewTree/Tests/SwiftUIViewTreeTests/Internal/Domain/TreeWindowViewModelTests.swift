
import SwiftUI
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeWindowViewModelTests {
    @Test
    func initialState() {
        //GIVEN
        var treeWindowViewModel: TreeWindowViewModel

        //WHEN
        treeWindowViewModel = TreeWindowViewModel()

        //THEN
        guard case .computingTree = treeWindowViewModel.uiState else {
            Issue.record("Unexpected initial state \(treeWindowViewModel.uiState)")
            return
        }
        #expect(treeWindowViewModel.isRecomputing == false)
    }

    @Test
    func computeViewTree_FirstTime() async {
        //GIVEN
        let treeWindowViewModel = TreeWindowViewModel()

        let originalView = Text("Hello, World!")
        let modifiedView = Text("Hello, World!").bold()

        //WHEN
        treeWindowViewModel.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        #expect(treeWindowViewModel.isRecomputing == false)
        try? await Task.sleep(for: .seconds(TreeWindowViewModel.waitTimeInSeconds + 0.5))

        //THEN
        #expect(treeWindowViewModel.isRecomputing == false)
        guard case .treeComputed(let computedUIState) = treeWindowViewModel.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeWindowViewModel.uiState)")
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
        let treeWindowViewModel = TreeWindowViewModel()

        let originalView = Text("Hello, World!")
        let modifiedView = Text("Hello, World!").bold()

        treeWindowViewModel.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        #expect(treeWindowViewModel.isRecomputing == false)
        try? await Task.sleep(for: .seconds(TreeWindowViewModel.waitTimeInSeconds + 0.5))

        #expect(treeWindowViewModel.isRecomputing == false)
        guard case .treeComputed = treeWindowViewModel.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeWindowViewModel.uiState)")
            return
        }

        //WHEN
        treeWindowViewModel.computeViewTree(
            maxDepth: .max,
            originalView: originalView,
            modifiedView: modifiedView
        )
        //THEN
        try? await Task.sleep(for: .seconds(0.2)) // mini-delay is needed because computeViewTree's logic is running in a Task
        #expect(treeWindowViewModel.isRecomputing == true) // if the delay is turned off this expectation might fail, and in that case this test doesn't make sense anymore

        try? await Task.sleep(for: .seconds(TreeWindowViewModel.waitTimeInSeconds + 0.5))
        #expect(treeWindowViewModel.isRecomputing == false)

        guard case .treeComputed(let computedUIState) = treeWindowViewModel.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeWindowViewModel.uiState)")
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
