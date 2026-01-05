
import Foundation
import Synchronization

@MainActor
@Observable
final class CollapsedNodesStore: Sendable {
    @TaskLocal static var shared = CollapsedNodesStore()

    @ObservationIgnored private let lock = NSLock()
    @ObservationIgnored private var _collapsedNodeIDs = Set<TreeNode.ID>([])

    private var collapsedNodeIDs: Set<TreeNode.ID> {
        get {
            self.access(keyPath: \.collapsedNodeIDs)
            return lock.withLock {
                _collapsedNodeIDs
            }
        }
        set {
            self.withMutation(keyPath: \.collapsedNodeIDs) {
                lock.withLock {
                    _collapsedNodeIDs = newValue
                }
            }
        }
    }

    func isCollapsed(nodeID: TreeNode.ID) -> Bool {
        collapsedNodeIDs.contains(nodeID)
    }

    func toggleCollapse(nodeID: TreeNode.ID) {
        if isCollapsed(nodeID: nodeID) {
            collapsedNodeIDs.remove(nodeID)
        } else {
            collapsedNodeIDs.insert(nodeID)
        }
    }

    func collapse(nodeID: TreeNode.ID) {
        collapsedNodeIDs.insert(nodeID)
    }
}
