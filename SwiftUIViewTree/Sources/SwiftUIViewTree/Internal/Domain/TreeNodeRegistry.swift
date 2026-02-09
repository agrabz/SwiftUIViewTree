
@MainActor
final class TreeNodeRegistry {
    @TaskLocal static var shared = TreeNodeRegistry()

    private(set) var registry: [Int: TreeNode] = [:]
    private(set) var allChangedNodes = [TreeNode]()

    func registerNode(serialNumber: Int, node: TreeNode) throws {
        if registry[serialNumber] == nil {
            registry[serialNumber] = node
        } else {
            throw TreeNodeRegistry.Error.nodeIsAlreadyRegistered
        }
    }

    func getRegisteredNodeWith(serialNumber: Int) -> TreeNode? {
        registry[serialNumber]
    }

    func registerChangedNode(_ node: TreeNode) {
        allChangedNodes.append(node)
        registry[node.serialNumber] = node
    }

    func isNodeChanged(serialNumber: Int) -> Bool {
        allChangedNodes.contains { $0.serialNumber == serialNumber }
    }

    func removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: Int) {
        allChangedNodes.removeAll { $0.serialNumber == serialNumberOfNodeToRemove }
    }
}

extension TreeNodeRegistry {
    enum Error: Swift.Error {
        case nodeIsAlreadyRegistered
    }
}
