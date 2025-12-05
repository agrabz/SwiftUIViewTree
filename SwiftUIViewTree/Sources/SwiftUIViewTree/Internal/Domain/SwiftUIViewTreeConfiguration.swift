
internal typealias Configuration = SwiftUIViewTreeConfiguration

@MainActor
final class SwiftUIViewTreeConfiguration {
    @TaskLocal static var shared = SwiftUIViewTreeConfiguration()

    var isMemoryAddressDiffingEnabled = false

    func applySettings(_ settings: [SwiftUIViewTreeSetting]) {
        for setting in settings {
            switch setting {
                case .enableMemoryAddressDiffing:
                    self.isMemoryAddressDiffingEnabled = true
            }
        }
    }
}

