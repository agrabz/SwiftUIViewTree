import SwiftUI

struct ViewTreeTraversalProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Traversing the view tree.")
                .font(.callout)
                .bold()
            Text("It might take a while. If this takes too long, consider using `maxDepth`.")
                .font(.caption)
        }
    }
}
