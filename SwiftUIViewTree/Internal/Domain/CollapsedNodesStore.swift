
import Foundation

@Observable
final class CollapsedNodesStore {
    static let shared = CollapsedNodesStore()
    private init() {}

    var collapsedNodeIDs: Set<String> = []

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

    func clear() {
        collapsedNodeIDs.removeAll()
    }
}
