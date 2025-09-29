import SwiftUI

struct ViewTreeTraversalProgressView: View {
    var body: some View {
        VStack {
            ProgressView()

            Text("Traversing the view tree.")
                .font(.callout)
                .bold()

            Text("It might take a while.")
                .font(.caption)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    .white.opacity(0.6),
                    .gray.opacity(0.6),
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
