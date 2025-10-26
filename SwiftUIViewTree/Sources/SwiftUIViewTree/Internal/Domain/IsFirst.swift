
@MainActor
final class IsFirst {
    @TaskLocal static var shared = IsFirst()

    private var isFirst = true

    func getValue() -> Bool {
        defer { isFirst = false }
        return isFirst
    }
}
