
import Testing
@testable import SwiftUIViewTreeKit

struct ViewTreeTrait: TestTrait, SuiteTrait, TestScoping {

    private let collapsedNodeStore: CollapsedNodesStore
    private let viewTreeLogger: ViewTreeLoggerProtocol

    init(
        collapsedNodeStore: @autoclosure () -> CollapsedNodesStore,
        viewTreeLogger: @autoclosure () -> ViewTreeLoggerProtocol
    ) {
        self.collapsedNodeStore = collapsedNodeStore()
        self.viewTreeLogger = viewTreeLogger()
    }

    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        try await CollapsedNodesStore.$shared.withValue(self.collapsedNodeStore) {
            try await ViewTreeLogger.$shared.withValue(self.viewTreeLogger) {
                try await function()
            }
        }
    }
}

extension Trait where Self == ViewTreeTrait {
    static func viewTree(
        collapsedNodesStore: CollapsedNodesStore = .init(),
        viewTreeLogger: ViewTreeLoggerProtocol = ViewTreeLogger()
    ) -> ViewTreeTrait {
        .init(
            collapsedNodeStore: collapsedNodesStore,
            viewTreeLogger: viewTreeLogger
        )
    }
}
