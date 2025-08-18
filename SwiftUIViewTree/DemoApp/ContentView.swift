import SwiftUI

struct ContentView: View {
    @State var isTapped = false

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            Text(isTapped ? "Yo what?" : "Hello, world!")
                .font(.largeTitle)
                .bold(isTapped ? true : false)
        }
//        .printViewTree()
//        .renderViewTree(maxDepth: 3)
        .renderViewTree()
    }
}

#Preview {
    ContentView()
}
