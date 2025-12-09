
import Foundation
import SwiftUI

enum UIConstants {
    enum ScreenRatioOf {
        enum OriginalContent {
            static let horizontal: CGFloat = 1/4
            static let vertical: CGFloat = 1/2

            static func of(_ axis: Axis) -> CGFloat {
                switch axis {
                    case .horizontal:
                        Self.horizontal
                    case .vertical:
                        Self.vertical
                }
            }
        }

        enum ViewTree {
            static let horizontal: CGFloat = 3/4
            static let vertical: CGFloat = 1/2

            static func of(_ axis: Axis) -> CGFloat { //TODO: duplicate
                switch axis {
                    case .horizontal:
                        Self.horizontal
                    case .vertical:
                        Self.vertical
                }
            }
        }
    }

    enum Color {
        static let collapsedNodeBackground = SwiftUI.Color.gray
        static let initialNodeBackground = SwiftUI.Color.purple
    }
}
