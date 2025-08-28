
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeContainerTests {
    @Test
    func initialState() async throws {
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
}

