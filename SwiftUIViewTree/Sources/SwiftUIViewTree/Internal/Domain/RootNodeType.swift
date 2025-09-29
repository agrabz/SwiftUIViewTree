
enum RootNodeType: String {
    case originalView
    case modifiedView

    var serialNumber: Int {
        switch self {
            case .originalView:
                -2
            case .modifiedView:
                -3
        }
    }
}
