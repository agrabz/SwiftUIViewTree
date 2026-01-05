

@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct TreeLevelerTests {
    @Test
    func `with one level`() async throws {
        //GIVEN
        let tree = Tree.createMock(
            parentNode: .createMock(),
            children: []
        )

        //WHEN
        let levels = TreeLeveler.getAllTreeLevels(of: tree)

        //THEN
        #expect(levels.count == 1)
    }

    @Test
    func `with two levels`() async throws {
        //GIVEN
        let tree = Tree.createMock(
            parentNode: .createMock(),
            children: [
                Tree.createMock(
                    parentNode: .createMock()
                ),
                Tree.createMock(
                    parentNode: .createMock()
                ),
            ]
        )

        //WHEN
        let levels = TreeLeveler.getAllTreeLevels(of: tree)

        //THEN
        #expect(levels.count == 2)
    }

    @Test
    func `with three levels`() async throws {
        //GIVEN
        let tree = Tree.createMock(
            parentNode: .createMock(),
            children: [
                Tree.createMock(
                    parentNode: .createMock(),
                    children: [
                        Tree.createMock(
                            parentNode: .createMock()
                        )
                    ]
                ),
                Tree.createMock(
                    parentNode: .createMock(),
                    children: [
                        Tree.createMock(
                            parentNode: .createMock()
                        )
                    ]
                ),
            ]
        )

        //WHEN
        let levels = TreeLeveler.getAllTreeLevels(of: tree)

        //THEN
        #expect(levels.count == 3)
    }
}


