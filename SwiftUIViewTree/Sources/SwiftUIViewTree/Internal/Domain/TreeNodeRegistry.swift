
@MainActor
final class TreeNodeRegistry {
    @TaskLocal static var shared = TreeNodeRegistry()

    private var registry: [Int: String] = [:]
    private(set) var allChangedNodes = [TreeNode]()

    func registerNode(serialNumber: Int, value: String) throws {
        if registry[serialNumber] == nil {
            registry[serialNumber] = value
        } else {
            throw TreeNodeRegistry.Error.nodeIsAlreadyRegistered
        }
    }

    func getRegisteredValueOfNodeWith(serialNumber: Int) -> String? {
        registry[serialNumber]
    }

    func registerChangedNode(_ node: TreeNode) {
        allChangedNodes.append(node)
        registry[node.serialNumber] = node.value
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
