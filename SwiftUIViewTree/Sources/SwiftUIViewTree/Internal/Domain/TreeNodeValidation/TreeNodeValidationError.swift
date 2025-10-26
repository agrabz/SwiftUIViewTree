
enum TreeNodeValidationError: String, Error {
    private static let prefix = "SwiftUIViewTree."

    case location = "location"
    case atomicBox = "AtomicBox"
    case atomicBuffer = "AtomicBuffer"

    var description: String {
        Self.prefix + self.rawValue
    }
}
