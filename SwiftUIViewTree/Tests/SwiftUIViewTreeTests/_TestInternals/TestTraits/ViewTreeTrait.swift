
import Testing
@testable import SwiftUIViewTree

struct ViewTreeTrait: TestTrait, SuiteTrait, TestScoping {

    private let collapsedNodeStore: CollapsedNodesStore
    private let treeNodeRegistry: TreeNodeRegistry
    private let viewTreeLogger: ViewTreeLoggerProtocol
    private let configuration: Configuration

    var isRecursive = true

    init(
        collapsedNodeStore: @autoclosure () -> CollapsedNodesStore,
        treeNodeRegistry: @autoclosure () -> TreeNodeRegistry,
        viewTreeLogger: @autoclosure () -> ViewTreeLoggerProtocol,
        configuration: @autoclosure () -> Configuration,
    ) {
        self.collapsedNodeStore = collapsedNodeStore()
        self.treeNodeRegistry = treeNodeRegistry()
        self.viewTreeLogger = viewTreeLogger()
        self.configuration = configuration()
    }

    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        //consider Factory if this grows further
        try await CollapsedNodesStore.$shared.withValue(self.collapsedNodeStore) {
            try await TreeNodeRegistry.$shared.withValue(self.treeNodeRegistry) {
                try await ViewTreeLogger.$shared.withValue(self.viewTreeLogger) {
                    try await Configuration.$shared.withValue(self.configuration) {
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
        viewTreeLogger: ViewTreeLoggerProtocol = MockViewTreeLogger(),
        configuration: Configuration = .init(),
    ) -> ViewTreeTrait {
        ViewTreeTrait(
            collapsedNodeStore: collapsedNodesStore,
            treeNodeRegistry: treeNodeRegistry,
            viewTreeLogger: viewTreeLogger,
            configuration: configuration
        )
    }
}
