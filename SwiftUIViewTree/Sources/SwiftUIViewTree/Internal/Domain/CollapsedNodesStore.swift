import Foundation
import Synchronization

@MainActor
@Observable
final class CollapsedNodesStore {
    @TaskLocal static var shared = CollapsedNodesStore()

    private let _collapsedNodeIDs = Mutex<Set<TreeNode.ID>>([])

    private var collapsedNodeIDs: Set<TreeNode.ID> {
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

    // New: a simple counter that changes on any toggle so SwiftUI can observe it.
    var changeToken: Int = 0

    func isCollapsed(nodeID: TreeNode.ID) -> Bool {
        collapsedNodeIDs.contains(nodeID)
    }

    func toggleCollapse(nodeID: TreeNode.ID) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
        // bump token to notify observers
        changeToken &+= 1
    }
}
