import SwiftUI

struct NodeMenuContent: View {
    let node: TreeNode

    var body: some View {
        Text("Type: `\(node.type)`")   //TODO: to come from node object or from a separate UIModel whose mapper is testable
        Text("Label: `\(node.label)`")
        Text("Value: `\(node.value)`")
        Text("DisplayStyle: `\(node.displayStyle)`")
        Text("SubjectType: `\(node.subjectType)`")
        Text("SuperclassMirror: `\(node.superclassMirror)`")
        Text("mirrorDescription: `\(node.mirrorDescription)`")
    }
}
