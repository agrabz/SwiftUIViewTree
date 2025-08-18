import SwiftUI

struct ContentView: View {
    @State var asd = false

    var body: some View {
        Button {
            asd.toggle()
        } label: {
            Text(asd ? "Yo what?" : "Hello, world!")
                .font(.largeTitle)
                .bold(asd ? true : false)
        }
//        .printViewTree()
//        .renderViewTree(maxDepth: 3)
        .renderViewTree()
    }
}

#Preview {
    ContentView()
}
