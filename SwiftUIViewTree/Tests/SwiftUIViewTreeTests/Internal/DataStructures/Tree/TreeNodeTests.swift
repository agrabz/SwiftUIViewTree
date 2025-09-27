
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeNodeTests {
    @Test
    func isParent_True() async throws {
        //GIVEN
        let parent = TreeNode.createMock(childrenCount: 2)
        //WHEN
        let isParent = parent.isParent
        //THEN
        #expect(isParent == true)
    }

    @Test
    func isParent_False() async throws {
        //GIVEN
        let parent = TreeNode.createMock(childrenCount: 0)
        //WHEN
        let isParent = parent.isParent
        //THEN
        #expect(isParent == false)
    }
}

