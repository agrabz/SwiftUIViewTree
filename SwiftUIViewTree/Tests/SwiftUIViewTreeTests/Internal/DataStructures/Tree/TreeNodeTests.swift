
@testable import SwiftUIViewTree
import Testing

@MainActor
@Suite(.viewTree())
struct TreeNodeTests {
    @MainActor
    struct Init {
        @MainActor
        struct RegisterChanges_True {
            @Test
            func getsRegistered_First() {
                //GIVEN
                let node = TreeNode.createMock(registerChanges: true)
                //WHEN
                let registeredValue = TreeNodeRegistry.shared.getRegisteredValueOfNodeWith(
                    serialNumber: node.serialNumber
                )
                //THEN
                #expect(registeredValue == node.value)
            }

            @Test(.viewTree(viewTreeLogger: SpyViewTreeLogger()))
            func getsRegistered_Twice_ThereIs_NO_ValueChange() {
                //GIVEN
                let node1 = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: "value",
                    serialNumber: 42
                )

                //WHEN
                _ = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: node1.value,
                    serialNumber: 42
                )

                //THEN
                #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.serialNumber == node1.serialNumber }) == false)
                guard let spyViewTreeLogger = ViewTreeLogger.shared as? SpyViewTreeLogger else {
                    Issue.record("ViewTreeLogger is not spy: \(ViewTreeLogger.shared)")
                    return
                }
                #expect(spyViewTreeLogger.hasBeenCalled == false)
            }

            @Test(.viewTree(viewTreeLogger: SpyViewTreeLogger()))
            func getsRegistered_Twice_There_IS_ValueChange() {
                //GIVEN
                let value1 = "value1"
                let value2 = "value2"

                let node1 = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: value1,
                    serialNumber: 42,
                    registerChanges: true
                )

                //WHEN
                _ = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: value2,
                    serialNumber: 42,
                    registerChanges: true
                )

                //THEN
                #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.serialNumber == node1.serialNumber }) == true)
                guard let spyViewTreeLogger = ViewTreeLogger.shared as? SpyViewTreeLogger else {
                    Issue.record("ViewTreeLogger is not spy: \(ViewTreeLogger.shared)")
                    return
                }
                #expect(spyViewTreeLogger.hasBeenCalled == true)
            }

            @Test(.viewTree(
                viewTreeLogger: SpyViewTreeLogger(),
                configuration: {
                    let config = Configuration()
                    config.applySettings([])
                    return config
                }()
            ))
            func `logger is NOT called WHEN value has memory address AND memory configuration is enabled`() throws {
                //GIVEN
                let value1 = MemoryAddressTests.mock1
                let value2 = MemoryAddressTests.mock2

                let node1 = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: value1,
                    serialNumber: 42,
                    registerChanges: true
                )

                //WHEN
                _ = TreeNode.createMock(
                    type: "type",
                    label: "label",
                    value: value2,
                    serialNumber: 42,
                    registerChanges: true
                )

                //THEN
                #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.serialNumber == node1.serialNumber }) == false)
                guard let spyViewTreeLogger = ViewTreeLogger.shared as? SpyViewTreeLogger else {
                    Issue.record("ViewTreeLogger is not spy: \(ViewTreeLogger.shared)")
                    return
                }
                #expect(spyViewTreeLogger.hasBeenCalled == false)

            }
        }

        @MainActor
        struct RegisterChanges_False {
            @Test func notRegistered() async throws {
                //GIVEN
                let registerChanges = false

                //WHEN
                _ = TreeNode.createMock(registerChanges: registerChanges)

                //THEN
                #expect(TreeNodeRegistry.shared.allChangedNodes.isEmpty)
            }
        }
    }

    @MainActor
    struct ShortenedVariables {
        @Test
        func `longer than 20 characters gets shortened`() throws {
            //GIVEN
            let string = "01234567890123456789+"
            try #require(string.count > 20)

            //WHEN
            let node = TreeNode.createMock(
                type: string,
                label: string,
                value: string
            )

            //THEN
            #expect(node.shortenedType == "\(string.prefix(20))...")
            #expect(node.shortenedLabel == "\(string.prefix(20))...")
            #expect(node.shortenedValue == "\(string.prefix(20))...")
        }

        @Test(
            arguments: [
            //GIVEN
            "0123456789012345678",
            "01234567890123456789"
        ])
        func `less or equal than 20 characters does NOT get shortened`(string: String) throws {
            try #require(string.count <= 20)

            //WHEN
            let node = TreeNode.createMock(
                type: string,
                label: string,
                value: string
            )

            //THEN
            #expect(node.shortenedType == string)
            #expect(node.shortenedLabel == string)
            #expect(node.shortenedValue == string)
        }
    }

    @MainActor
    struct IsCollapsed {
        @Test
        func `isCollapsed is false on init`() throws {
            //GIVEN
            let node: TreeNode

            //WHEN
            node = TreeNode.createMock()

            //THEN
            #expect(node.isCollapsed == false)
        }

        @Test
        func `isCollapsed true when collapsing it`() throws {
            //GIVEN
            let node = TreeNode.createMock()

            //WHEN
            CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)

            //THEN
            #expect(node.isCollapsed == true)
        }

        @Test
        func `isCollapsed is false when collapsing then re-expanding it`() throws {
            //GIVEN
            let node = TreeNode.createMock()

            CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)
            #expect(node.isCollapsed == true)

            //WHEN
            CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)

            //THEN
            #expect(node.isCollapsed == false)
        }
    }

    @MainActor
    struct IsParent {
        @Test
        func `true`() async throws {
            //GIVEN
            let parent = TreeNode.createMock()
            parent.descendantCount = 2
            //WHEN
            let isParent = parent.isParent
            //THEN
            #expect(isParent == true)
        }

        @Test
        func `false`() async throws {
            //GIVEN
            let notParent = TreeNode.createMock()
            notParent.descendantCount = 0
            //WHEN
            let isParent = notParent.isParent
            //THEN
            #expect(isParent == false)
        }
    }

    @MainActor
    struct BackgroundColor {
        @Test
        func noChange() {
            //GIVEN
            let node = TreeNode.createMock()
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == LinkedColorList().colors.first)
        }

        @Test
        func isCollapsed() {
            //GIVEN
            let node = TreeNode.createMock()
            CollapsedNodesStore.shared.toggleCollapse(nodeID: node.id)
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == UIConstants.Color.collapsedNodeBackground)
        }

        @Test
        func hasChanged() {
            //GIVEN
            let node = TreeNode.createMock()
            node.setValueWithAnimation(to: "new value")
            TreeNodeRegistry.shared.registerChangedNode(node)
            //WHEN
            let result = node.backgroundColor
            //THEN
            #expect(result == LinkedColorList().colors.safeGetElement(at: 1))
            #expect(TreeNodeRegistry.shared.allChangedNodes.contains(where: { $0.id == node.id }) == false)
        }
    }
}
