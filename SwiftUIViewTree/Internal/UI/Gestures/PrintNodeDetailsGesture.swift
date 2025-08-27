
import SwiftUI

struct PrintNodeDetailsGesture: Gesture {
    @Binding var node: TreeNode

    var body: some Gesture {
        TapGesture()
            .onEnded { _ in
                print(
                    """
                        
                    Node Details:
                        Label: \(node.label)
                        Type: \(node.type)
                        Value: \(node.value)
                        DisplayStyle: \(node.displayStyle)
                        SubjectType: \(node.subjectType)
                        SuperclassMirror: \(node.superclassMirror)
                        mirrorDescription: \(node.mirrorDescription)
                        
                    """
                )
            }
    }
}
