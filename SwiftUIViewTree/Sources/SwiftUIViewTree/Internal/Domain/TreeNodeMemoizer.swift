
@MainActor
final class TreeNodeMemoizer {
    static let shared = TreeNodeMemoizer()

    private var memo: [Int: String] = [:]
    private(set) var allChangedNodes = [TreeNode]()

    func registerNode(serialNumber: Int, value: String) throws {
        if memo[serialNumber] == nil {
            memo[serialNumber] = value
        } else {
            throw TreeNodeMemoizer.Error.nodeIsAlreadyRegistered
        }
    }

    func getRegisteredValueOfNodeWith(serialNumber: Int) -> String? {
        memo[serialNumber]
    }

    func registerChangedNode(_ node: TreeNode) {
        allChangedNodes.append(node)
        memo[node.serialNumber] = node.value
    }

    func isNodeChanged(serialNumber: Int) -> Bool {
        allChangedNodes.contains { $0.serialNumber == serialNumber }
    }

    func removeNodeFromAllChangedNodes(serialNumberOfNodeToRemove: Int) {
        allChangedNodes.removeAll { $0.serialNumber == serialNumberOfNodeToRemove }
    }
}

extension TreeNodeMemoizer {
    enum Error: Swift.Error {
        case nodeIsAlreadyRegistered
    }
}
