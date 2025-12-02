
import SwiftUI

struct PrintNodeDetailsGesture: Gesture {
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
