
import SwiftUI

struct NodeBadge: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .bold()
            .frame(width: 16, height: 16)
            .font(.body)
            .foregroundColor(.black)
            .padding(8.0)
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .offset(
                x: 8,
                y: -8
            )
    }
}
