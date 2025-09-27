
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct TreeTests {
    @Test
    func subscript_FOUND() async throws {
        //GIVEN
        let node = TreeNode.createMock()
        let tree = Tree(node: node)

        //WHEN
        let foundNode = tree[node.serialNumber]

        //THEN
        #expect(foundNode != nil)
        #expect(foundNode == node)
    }

    @Test
    func subscript_NOT_FOUND() async throws {
        //GIVEN
        let node = TreeNode.createMock()
        let tree = Tree(node: node)

        //WHEN
        let foundNode = tree[2_000_000]

        //THEN
        #expect(foundNode == nil)
        #expect(foundNode != node)
    }
}

//subscript(serialNumber: Int) -> TreeNode? {
//    if parentNode.serialNumber == serialNumber {
//        return parentNode
//    } else {
//        for child in children {
//            if let found = child[serialNumber] {
//                return found
//            }
//        }
//        return nil
//    }
//}
