import SwiftUI

struct ParentNodeView: View {
    @Environment(\.treeCoordinator) var treeCoordinator: TreeCoordinator
    @Binding var parentNode: TreeNode

    var body: some View {
        Menu {
//            List {
                Text("Type: `\(parentNode.type)`")   //TODO: to come from node object or from a separate UIModel whose mapper is testable
                Text("Label: `\(parentNode.label)`")
                Text("Value: `\(parentNode.value)`")
                Text("DisplayStyle: `\(parentNode.displayStyle)`")
                Text("SubjectType: `\(parentNode.subjectType)`")
                Text("SuperclassMirror: `\(parentNode.superclassMirror)`")
                Text("mirrorDescription: `\(parentNode.mirrorDescription)`")
//            }

        } label: {
            NodeView(
                node: $parentNode
            )
            .anchorPreference(key: NodeCenterPreferenceKey.self, value: .center) { anchor in
                [parentNode.id: anchor]
            }
        }

//        .onTapGesture {
//            treeCoordinator.popover = .node(self.parentNode)
//        }
    }
}
