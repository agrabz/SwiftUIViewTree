
import SwiftUI

struct PrintNodeFullDetailsGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                print(
                    """
                        
                    Node Details:
                        Label: \(node.label)
                        Type: \(node.type)
                        Value: \(node.value)

                    """
                    //TODO: Children count: \(node.children.count)
                )
            }
    }
}
