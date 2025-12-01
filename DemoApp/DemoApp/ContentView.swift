
import SwiftUI
import SwiftUIViewTree

struct SubviewToTestWith: View {
    @Binding var isTapped: Bool

    var body: some View {
        Text(isTapped ? "Yo what?" : "Hello, World!")
            .bold(isTapped ? true : false)
            .notifyViewTreeOnChanges(of: self)
//            .renderViewTree(of: self)
        }
}

struct ContentView: View {
    @State private var isTapped = false

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                SubviewToTestWith(isTapped: $isTapped)
            }
            .padding()
        }
        .renderViewTree(of: self)
//        .renderViewTree(of: self, renderMode: .treeGraph(showTreeInitially: true))
//        .renderViewTree(of: self, renderMode: .treeGraph(showTreeInitially: false))
//        .renderViewTree(of: self, renderMode: .never)
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
