
import Foundation
import Synchronization

@Observable
final class CollapsedNodesStore: Sendable {
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

    func isCollapsed(nodeID: TreeNode.ID) -> Bool {
        collapsedNodeIDs.contains(nodeID)
    }

    //TODO: String should only be the ID of the node, check again that conf talk about this.
    func toggleCollapse(nodeID: TreeNode.ID) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
    }
}
