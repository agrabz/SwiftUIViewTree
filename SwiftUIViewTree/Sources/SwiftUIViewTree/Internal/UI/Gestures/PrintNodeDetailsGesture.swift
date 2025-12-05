
import SwiftUI

struct PrintNodeDetailsGesture: Gesture {
    let printFullDetails: Bool
    @Binding var node: TreeNode

    var printableLabel: String {
        printFullDetails ? node.label : node.shortenedLabel
    }

    var printableType: String {
        printFullDetails ? node.type : node.shortenedType
    }

    var printableValue: String {
        printFullDetails ? node.value : node.shortenedValue
    }

    var body: some Gesture {
        TapGesture(count: printFullDetails ? 3 : 1)
            .onEnded { _ in
                print(
                    """
                        
                    Node Details:
                        Label: \(self.printableLabel)
                        Type: \(self.printableType)
                        Value: \(self.printableValue)

                    """
                )
            }
    }
}
