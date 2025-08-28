
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
        try? await Task.sleep(for: .seconds(2))

        //THEN
        #expect(treeContainer.isRecomputing == false)
        guard case .treeComputed(let computedUIState) = treeContainer.uiState else {
            Issue.record("Unexpected state after computing the tree \(treeContainer.uiState)")
            return
        }

        #expect(computedUIState.treeBreakDownOfOriginalContent.children.safeGetElement(at: 0)?.parentNode.id == "originalView-Text-Optional(Swift.Mirror.DisplayStyle.struct)-Text-nil-Mirror for Text-0-2")
        #expect(computedUIState.treeBreakDownOfOriginalContent.children.safeGetElement(at: 0)?.children.count ?? 0 > 0) // More thorough test doesn't seem to be justified
        #expect(computedUIState.treeBreakDownOfOriginalContent.children.safeGetElement(at: 1)?.parentNode.id == "modifiedView-Text-Optional(Swift.Mirror.DisplayStyle.struct)-Text-nil-Mirror for Text-0-2")
        #expect(computedUIState.treeBreakDownOfOriginalContent.children.safeGetElement(at: 1)?.children.count ?? 0 > 0) // More thorough test doesn't seem to be justified
    }
}
