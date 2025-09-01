
import Foundation
import Synchronization

@MainActor
@Observable
final class CollapsedNodesStore: Sendable {
    static var shared = CollapsedNodesStore()

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

    //TODO: String should only be the ID of the node, check again that conf talk about this.
    func toggleCollapse(nodeID: String) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
    }
}
