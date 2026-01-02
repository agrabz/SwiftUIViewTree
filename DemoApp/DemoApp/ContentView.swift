
import SwiftUI
import SwiftUIViewTree

struct SubviewToTestWith: View {
    @Binding var isTapped: Bool

    var body: some View {
        Text(isTapped ? "Yo what?" : "Hello, World!")
            .bold(isTapped)
            .notifyViewTreeOnChanges(of: self)
//            .renderViewTree(of: self)
        }
}

struct MyType {
    let var10: String = "var10"
    let var11: String = "var11"
    let var12: String = "var12"
    let var13: String = "var13"
    let var14: String = "var14"
    let var15: String = "var15"
    let var16: String = "var16"
    let var17: String = "var17"
    let var18: String = "var18"
    let var19: String = "var19"
    let var20: String = "var20"
    let var21: String = "var21"
    let var22: String = "var22"
}

struct ContentView: View {
    @State private var isTapped = false
    private let asd = MyType()

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                SubviewToTestWith(isTapped: $isTapped)
//                Text(isTapped ? "Yo what?" : "Hello, World!")
//                    .bold(isTapped)
            }
            .padding()
        }
        .renderViewTree(of: self)
//        .renderViewTree(of: self, settings: [.enableMemoryAddressDiffing])
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
