
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

    var index: Int {
        switch self {
            case .originalView:
                0
            case .modifiedView:
                1
        }
    }
}
