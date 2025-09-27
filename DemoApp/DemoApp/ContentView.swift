
import SwiftUI
import SwiftUIViewTree

struct ContentView: View {
    @State var isTapped = false

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(isTapped ? "Yo what?" : "Hello, world!")
                    .bold(isTapped ? true : false)
            }
            .padding()
        }
        .renderViewTree(of: self)
    }
}

//struct ContentView: View {
//    @State var isTapped = false
//
//    var body: some View {
//        Button {
//            isTapped.toggle()
//        } label: {
//            Text(isTapped ? "Yo what?" : "Hello, world!")
//                .font(.largeTitle)
//                .bold(isTapped ? true : false)
//        }
//        .renderViewTree(of: self)
//    }
//}


#Preview {
    ContentView()
}
