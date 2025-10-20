
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite
struct SubtreeMatcherTests {
    @Test
    func match() async throws {
        //GIVEN
        let originalSubTree = Tree(
            node: .createMock(
                type: "subTreeType",
                label: "subTreeLabel",
                value: "subTreeValue OLD"
            )
        )

        let modifiedSubTree = Tree(
            node: .createMock(
                type: "subTreeType",
                label: "subTreeLabel",
                value: "subTreeValue NEW"
            )
        )

        let mainTree = Tree(
            node: .createMock(
                type: "mainTreeType",
                label: "mainTreeLabel",
                value: "mainTreeValue"
            ),
            children: [
                originalSubTree,
                Tree(
                    node: .createMock()
                )
            ]
        )

        //WHEN
        let result = SubtreeMatcher.findMatchingSubtree(
            in: mainTree,
            matching: modifiedSubTree
        )

        //THEN
        guard let result else {
            Issue.record("Unexpectedly unfound subtree match")
            return
        }
        let (changed: changedTree, original: _) = result
        #expect(changedTree == modifiedSubTree)
    }

    @Test
    func NO_match() async throws {
        //GIVEN
        let someSubTree = Tree(
            node: .createMock(
                type: "subTreeType",
                label: "subTreeLabel",
                value: "subTreeValue OLD"
            )
        )

        let mainTree = Tree(
            node: .createMock(
                type: "mainTreeType",
                label: "mainTreeLabel",
                value: "mainTreeValue"
            ),
            children: [
                Tree(
                    node: .createMock()
                )
            ]
        )

        //WHEN
        let result = SubtreeMatcher.findMatchingSubtree(
            in: mainTree,
            matching: someSubTree
        )

        //THEN
        #expect(result == nil)
    }
}


