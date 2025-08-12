import SwiftUI

struct ContentView: View {
    @State var asd = false

    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
        Button {
            asd.toggle()
        } label: {
            Text("Hello, world!")
                .font(.largeTitle)
                .bold(asd ? true : false)
        }
//        .printViewTree()
//        .renderViewTree(maxDepth: 3)
//        .renderViewTree()
        .modi()
    }
}

#Preview {
    ContentView()
}
