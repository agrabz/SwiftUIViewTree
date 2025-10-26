
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeFlattenerTests {
    @Test
    func flatten() async throws {
        //GIVEN
        let parent = TreeNode.createMock()
        let child1 = TreeNode.createMock()
        let child2 = TreeNode.createMock()

        let treeToFlatten = Tree(
            node: parent,
            children: [
                Tree(node: child1),
                Tree(node: child2),
            ]
        )

        //WHEN
        let flattenedTree = TreeFlattener.flatten(treeToFlatten)

        //THEN
        #expect(flattenedTree.first == parent)
        #expect(flattenedTree.safeGetElement(at: 1) == child1)
        #expect(flattenedTree.safeGetElement(at: 2) == child2)
        #expect(flattenedTree.safeGetElement(at: 3) == nil)
    }
}


