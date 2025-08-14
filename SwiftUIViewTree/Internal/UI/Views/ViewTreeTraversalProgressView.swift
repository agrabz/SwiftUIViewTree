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
        .padding()
        .background(
            LinearGradient(
                colors: [
                    .white.opacity(0.5),
                    .gray.opacity(0.5),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 0.5)
        }
    }
}
