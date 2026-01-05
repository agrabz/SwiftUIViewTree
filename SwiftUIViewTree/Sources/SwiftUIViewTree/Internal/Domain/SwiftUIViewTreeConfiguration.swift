
internal typealias Configuration = SwiftUIViewTreeConfiguration

@MainActor
final class SwiftUIViewTreeConfiguration {
    @TaskLocal static var shared = SwiftUIViewTreeConfiguration()

    var isMemoryAddressDiffingEnabled = false
    var maxChildCountForAutoCollapsingParentNodes = 10

    func applySettings(_ settings: [SwiftUIViewTreeSetting]) {
        for setting in settings {
            switch setting {
                case .enableMemoryAddressDiffing:
                    self.isMemoryAddressDiffingEnabled = true
                case .maxChildCountForAutoCollapsingParentNodes(let maxChildrenCount):
                    self.maxChildCountForAutoCollapsingParentNodes = maxChildrenCount
            }
        }
    }
}
