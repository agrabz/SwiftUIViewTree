
import SwiftUI
import SwiftUIViewTree

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//        .renderViewTree(of: self)
//    }
//}

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
        .renderViewTree(of: self)
    }
}


#Preview {
    ContentView()
}
