
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

struct MyBigType {
    var var10: String = "var10"
    var var11: String = "var11"
    var var12: String = "var12"
    var var13: String = "var13"
    var var14: String = "var14"
    var var15: String = "var15"
    var var16: String = "var16"
    var var17: String = "var17"
    var var18: String = "var18"
    var var19: String = "var19"
    var var20: String = "var20"
    var var21: String = "var21"
    var var22: String = "var22"
    let myBigChildType = MyBigChildType()
}

struct MyBigChildType {
    let let10: String = "let10"
    let let11: String = "let11"
    let let12: String = "let12"
    let let13: String = "let13"
    let let14: String = "let14"
    let let15: String = "let15"
    let let16: String = "let16"
    let let17: String = "let17"
    let let18: String = "let18"
    let let19: String = "let19"
    let let20: String = "let20"
    let let21: String = "let21"
    let let22: String = "let22"
}

struct ContentView: View {
    @State private var isTapped = false
    private let myBigObject = MyBigType()

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
