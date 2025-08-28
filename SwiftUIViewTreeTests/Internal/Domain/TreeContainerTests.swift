
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
    func computeViewTree() async {
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
        
    }
}
