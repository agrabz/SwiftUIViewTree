
@MainActor
final class IsFirst {
    static let shared = IsFirst()
    private init() {}
    var isFirst = true
}
