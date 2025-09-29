
import SwiftUI

struct NodeBadge: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .bold()
            .frame(minWidth: 16, idealHeight: 16)
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
