import SwiftUI

struct NodeCenterPreferenceKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: Anchor<CGPoint>] {
        [:]
    }

    static func reduce(value: inout [ID: Anchor<CGPoint>], nextValue: () -> [ID: Anchor<CGPoint>]) {
        value = value.merging(
            nextValue(),
            uniquingKeysWith: { $1 }
        )
    }
}
