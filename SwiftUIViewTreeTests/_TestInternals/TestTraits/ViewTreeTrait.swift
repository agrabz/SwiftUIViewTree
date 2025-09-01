
import Testing
@testable import SwiftUIViewTree

struct ViewTreeTrait: TestTrait, SuiteTrait, TestScoping {

    private let collapsedNodeStore: CollapsedNodesStore

    init(collapsedNodeStore: @autoclosure () -> CollapsedNodesStore) {
        self.collapsedNodeStore = collapsedNodeStore()
    }

    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        try await CollapsedNodesStore.$shared.withValue(collapsedNodeStore) {
            try await function()
        }
    }
}

extension Trait where Self == ViewTreeTrait {
    static var viewTree: ViewTreeTrait { .init(collapsedNodeStore: .init()) }
}
