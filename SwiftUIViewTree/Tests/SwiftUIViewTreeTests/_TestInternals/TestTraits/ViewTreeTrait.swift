
import Testing
@testable import SwiftUIViewTree

struct ViewTreeTrait: TestTrait, SuiteTrait, TestScoping {

    private let collapsedNodeStore: CollapsedNodesStore
    private let treeNodeRegistry: TreeNodeRegistry
    private let viewTreeLogger: ViewTreeLoggerProtocol

    init(
        collapsedNodeStore: @autoclosure () -> CollapsedNodesStore,
        treeNodeRegistry: @autoclosure () -> TreeNodeRegistry,
        viewTreeLogger: @autoclosure () -> ViewTreeLoggerProtocol
    ) {
        self.collapsedNodeStore = collapsedNodeStore()
        self.treeNodeRegistry = treeNodeRegistry()
        self.viewTreeLogger = viewTreeLogger()
    }

    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        try await CollapsedNodesStore.$shared.withValue(self.collapsedNodeStore) {
            try await TreeNodeRegistry.$shared.withValue(self.treeNodeRegistry) {
                try await ViewTreeLogger.$shared.withValue(self.viewTreeLogger) {
                    try await function()
                }
            }
        }
    }
}

extension Trait where Self == ViewTreeTrait {
    static func viewTree(
        collapsedNodesStore: CollapsedNodesStore = .init(),
        treeNodeRegistry: TreeNodeRegistry = .init(),
        viewTreeLogger: ViewTreeLoggerProtocol = ViewTreeLogger()
    ) -> ViewTreeTrait {
        .init(
            collapsedNodeStore: collapsedNodesStore,
            treeNodeRegistry: treeNodeRegistry,
            viewTreeLogger: viewTreeLogger
        )
    }
}
