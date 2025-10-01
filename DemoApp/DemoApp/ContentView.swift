
import SwiftUI
import SwiftUIViewTree

struct Subview2: View {
    @Binding var isTapped: Bool

    var body: some View {
        Text(isTapped ? "Yo what?" : "Hello, World!")
            .bold(isTapped ? true : false)
            .notifyViewTree(of: self)
        }
}

struct ContentView: View {
    @State private var isTapped = false

    var body: some View {
        let a = Subview2(isTapped: $isTapped)
        Button {
            isTapped.toggle()
        } label: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                a
//                    .imReRenderingMyselfAndLettingYouKnowSoYouCanUpdateTheViewTree()
            }
            .padding()
        }
        .renderViewTree(of: a)
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
