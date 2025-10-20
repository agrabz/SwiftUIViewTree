
import Testing
@testable import SwiftUIViewTree

struct ViewTreeTrait: TestTrait, SuiteTrait, TestScoping {

    private let collapsedNodeStore: CollapsedNodesStore
    private let treeNodeRegistry: TreeNodeRegistry
    private let viewTreeLogger: ViewTreeLoggerProtocol
    private let isFirst: IsFirst

    init(
        collapsedNodeStore: @autoclosure () -> CollapsedNodesStore,
        treeNodeRegistry: @autoclosure () -> TreeNodeRegistry,
        viewTreeLogger: @autoclosure () -> ViewTreeLoggerProtocol,
        isFirst: @autoclosure () -> IsFirst
    ) {
        self.collapsedNodeStore = collapsedNodeStore()
        self.treeNodeRegistry = treeNodeRegistry()
        self.viewTreeLogger = viewTreeLogger()
        self.isFirst = isFirst()
    }

    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        //TODO: ehh I want Factory instead
        try await CollapsedNodesStore.$shared.withValue(self.collapsedNodeStore) {
            try await TreeNodeRegistry.$shared.withValue(self.treeNodeRegistry) {
                try await ViewTreeLogger.$shared.withValue(self.viewTreeLogger) {
                    try await IsFirst.$shared.withValue(self.isFirst) {
                        try await function()
                    }
                }
            }
        }
    }
}

extension Trait where Self == ViewTreeTrait {
    static func viewTree(
        collapsedNodesStore: CollapsedNodesStore = .init(),
        treeNodeRegistry: TreeNodeRegistry = .init(),
        viewTreeLogger: ViewTreeLoggerProtocol = ViewTreeLogger(),
        isFirst: IsFirst = IsFirst()
    ) -> ViewTreeTrait {
        ViewTreeTrait(
            collapsedNodeStore: collapsedNodesStore,
            treeNodeRegistry: treeNodeRegistry,
            viewTreeLogger: viewTreeLogger,
            isFirst: isFirst
        )
    }
}
