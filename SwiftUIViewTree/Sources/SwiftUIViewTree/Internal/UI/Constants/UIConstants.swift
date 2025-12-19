
import Foundation
import SwiftUI

enum UIConstants {
    enum ScreenRatio {
        static func of(_ section: Section, on axis: Axis) -> CGFloat {
            switch (section, axis) {
                case (.originalContent, .horizontal):
                    Section.OriginalContent.horizontal
                case (.originalContent, .vertical):
                    Section.OriginalContent.vertical
                case (.viewTree, .horizontal):
                    Section.ViewTree.horizontal
                case (.viewTree, .vertical):
                    Section.ViewTree.vertical
            }
        }

        enum Section {
            case originalContent
            case viewTree

            enum OriginalContent {
                static var horizontal: CGFloat {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        1/4
                    } else {
                        1/2
                    }
                }
                static let vertical: CGFloat = 1/2
            }

            enum ViewTree {
                static var horizontal: CGFloat {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        3/4
                    } else {
                        1/2
                    }
                }
                static let vertical: CGFloat = 1/2
            }
        }
    }

    enum Color {
        static let collapsedNodeBackground = SwiftUI.Color.gray
        static let initialNodeBackground = SwiftUI.Color.purple
    }
}
