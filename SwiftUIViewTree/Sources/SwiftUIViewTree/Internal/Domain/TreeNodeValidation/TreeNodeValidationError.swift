
enum TreeNodeValidationError: Error {
    case location
    case atomicBox
    case atomicBuffer
    
    var description: String {
        let prefix = "SwiftUIViewTree."
        let postfix =
        switch self {
            case .location:
                "location"
            case .atomicBox:
                "AtomicBox"
            case .atomicBuffer:
                "AtomicBuffer"
        }
        return prefix + postfix
    }
}
