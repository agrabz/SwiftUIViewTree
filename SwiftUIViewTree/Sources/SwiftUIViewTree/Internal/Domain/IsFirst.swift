
@MainActor
final class IsFirst {
    @TaskLocal static var shared = IsFirst()

    var isFirst = true
}
