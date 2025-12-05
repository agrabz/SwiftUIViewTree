
enum TreeNodeValidationError: String, Error {
    private static let prefix = "SwiftUIViewTree."

    case location = "location"
    case atomicBox = "AtomicBox"
    case atomicBuffer = "AtomicBuffer"
    case localizedTextStorage = "LocalizedTextStorage"
    case storage = "Storage"

    var description: String {
        Self.prefix + self.rawValue
    }
}
