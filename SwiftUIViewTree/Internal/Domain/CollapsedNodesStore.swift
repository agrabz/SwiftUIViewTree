
import Foundation
import Synchronization

@Observable
final class CollapsedNodesStore: Sendable {
    @TaskLocal static var shared = CollapsedNodesStore()

    private let _collapsedNodeIDs = Mutex<Set<String>>([])

    private var collapsedNodeIDs: Set<String> {
        get {
            self.access(keyPath: \.collapsedNodeIDs)
            return _collapsedNodeIDs.withLock { set in
                set
            }
        }
        set {
            self.withMutation(keyPath: \.collapsedNodeIDs) {
                _collapsedNodeIDs.withLock { set in
                    set = newValue
                }
            }
        }
    }

    func isCollapsed(nodeID: String) -> Bool {
        collapsedNodeIDs.contains(nodeID)
    }

    func toggleCollapse(nodeID: String) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
    }
}
