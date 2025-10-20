
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

            //WHEN
            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //THEN
            #expect(tree1 == tree2)
        }

        @Test
        func typesAreMatching_LabelsAreNOTMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "matchingType", label: "label")
            let node2 = TreeNode.createMock(type: "matchingType", label: "NON_matchingLabel")

            //WHEN
            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //THEN
            #expect(tree1 != tree2)
        }

        @Test
        func typesAreNOTMatching_LabelsAreMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "type", label: "matchingLabel")
            let node2 = TreeNode.createMock(type: "NON_matchingType", label: "matchingLabel")

            //WHEN
            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //THEN
            #expect(tree1 != tree2)
        }

        @Test
        func typesAreNOTMatching_LabelsAreNOTMatching() async {
            //GIVEN
            let node1 = TreeNode.createMock(type: "type", label: "label")
            let node2 = TreeNode.createMock(type: "NON_matchingType", label: "NON_matchingLabel")

            //WHEN
            let tree1 = Tree(node: node1)
            let tree2 = Tree(node: node2)

            //THEN
            #expect(tree1 != tree2)
        }

        @MainActor
        struct Children {
            @Test
            func ARE_Equal() async {
                //GIVEN
                let parent = TreeNode.createMock()
                let child1 = TreeNode.createMock()
                let child2 = TreeNode.createMock()

                //WHEN
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

                //THEN
                #expect(tree1 == tree2)
            }

            @Test
            func NOT_Equal() async {
                //GIVEN
                let parent = TreeNode.createMock()
                let child1 = TreeNode.createMock()
                let child2 = TreeNode.createMock()
                let child3 = TreeNode.createMock()

                //WHEN
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

                //THEN
                #expect(tree1 != tree2)
            }

            //TODO: mismatching number of children should fail too! review implementation
        }
    }
}
