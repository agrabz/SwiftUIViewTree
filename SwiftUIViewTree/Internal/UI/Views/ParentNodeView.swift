import SwiftUI

struct ParentNodeView: View {
    @State var dummy = false //TODO: without this the first isRecomputing updates every node color, not just the ones that got a new value. there used to be another state here for navigation, hence its location
    @Binding var parentNode: TreeNode

    var body: some View {

        if parentNode.label == "modifiers" && isViewPrintChangesEnabled {
            let _ = print()
            let _ = print("ParentNodeView")
            let _ = Self._printChanges()
            let _ = print()
        }

        NodeView(
            node: $parentNode
        )
//        .simultaneousGesture(
//            TapGesture()
//                .onEnded { _ in
//                    print(
//                        """
//                            
//                        Node Details:
//                            Label: \(parentNode.label)
//                            Type: \(parentNode.type)
//                            Value: \(parentNode.value)
//                            DisplayStyle: \(parentNode.displayStyle)
//                            SubjectType: \(parentNode.subjectType)
//                            SuperclassMirror: \(parentNode.superclassMirror)
//                            mirrorDescription: \(parentNode.mirrorDescription)
//                            
//                        """
//                    )
//                }
//        )
        .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
            [parentNode.id: anchor]
        }
    }
}
