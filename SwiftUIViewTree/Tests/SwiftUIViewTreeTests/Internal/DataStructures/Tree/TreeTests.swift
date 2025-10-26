
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
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
        #expect(foundNode?.id == node.id)
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
        #expect(foundNode?.id != node.id)
    }

    @MainActor
    struct Equality {
        @Test
        func typesAreMatching_LabelsAreMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "matchingType", label: "matchingLabel")
            let node2 = TreeNode.createMock(type: "matchingType", label: "matchingLabel")

            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //WHEN
            let result = tree1 == tree2

            //THEN
            #expect(result == true)
        }

        @Test
        func typesAreMatching_LabelsAreNOTMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "matchingType", label: "label")
            let node2 = TreeNode.createMock(type: "matchingType", label: "NON_matchingLabel")

            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //WHEN
            let result = tree1 == tree2

            //THEN
            #expect(result == false)
        }

        @Test
        func typesAreNOTMatching_LabelsAreMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "type", label: "matchingLabel")
            let node2 = TreeNode.createMock(type: "NON_matchingType", label: "matchingLabel")

            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //WHEN
            let result = tree1 == tree2

            //THEN
            #expect(result == false)
        }

        @Test
        func typesAreNOTMatching_LabelsAreNOTMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "type", label: "label")
            let node2 = TreeNode.createMock(type: "NON_matchingType", label: "NON_matchingLabel")

            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //WHEN
            let result = tree1 == tree2

            //THEN
            #expect(result == false)
        }

        @MainActor
        struct Children {
            @Test
            func ARE_Equal() async {
                //GIVEN
                let parent = TreeNode.createMock()
                let child1 = TreeNode.createMock()
                let child2 = TreeNode.createMock()

                let tree1 = Tree(
                    node: parent,
                    children: [
                        Tree(node: child1),
                        Tree(node: child2),
                    ]
                )
                let tree2 = Tree(
                    node: parent,
                    children: [
                        Tree(node: child1),
                        Tree(node: child2),
                    ]
                )
                //WHEN
                let result = tree1 == tree2

                //THEN
                #expect(result == true)
            }

            @Test
            func NOT_Equal() async {
                //GIVEN
                let parent = TreeNode.createMock()
                let child1 = TreeNode.createMock()
                let child2 = TreeNode.createMock()
                let child3 = TreeNode.createMock()

                let tree1 = Tree(
                    node: parent,
                    children: [
                        Tree(node: child1),
                        Tree(node: child2),
                    ]
                )
                let tree2 = Tree(
                    node: parent,
                    children: [
                        Tree(node: child2),
                        Tree(node: child3),
                    ]
                )
                //WHEN
                let result = tree1 == tree2

                //THEN
                #expect(result == false)
            }

            //TODO: mismatching number of children should fail too! review implementation
        }
    }
}
