
import SwiftUI

struct PrintNodeShortenedDetailsGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        TapGesture()
            .onEnded { _ in
                print(
                    """
                        
                    Node Details:
                        Label: \(node.shortenedLabel)
                        Type: \(node.shortenedType)
                        Value: \(node.shortenedValue)

                    """
                )
            }
    }
}

struct PrintNodeFullDetailsGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        LongPressGesture()
//        TapGesture(count: 3)
            .onEnded { _ in
                print(
                    """
                        
                    Node Details:
                        Label: \(node.label)
                        Type: \(node.type)
                        Value: \(node.value)

                    """
                )
            }
    }
}
