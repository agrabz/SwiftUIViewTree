import SwiftUI

struct ScrollableZoomableTreeView: View {
    @State var tree: Tree

    var body: some View {
        List {
            OutlineGroup(tree.children, children: \.optionalChildren) { grandChild in //rootview is not important hence the start from tree.children
                    HStack {
                        Text(grandChild.parentNode.shortenedLabel)
                            .font(.subheadline)
                            .fontWeight(.bold)

                        Text(grandChild.parentNode.shortenedType)
                            .font(.caption)
                            .bold()

                        Text(grandChild.parentNode.shortenedValue)
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .italic()

                        Text("[" + "\(grandChild.parentNode.descendantCount)" + "]")
                            .font(.caption2)
                            .fontDesign(.rounded)
                    }
                }
            .listRowBackground(Color.cyan)
        }
        .listStyle(.plain)
//        Zoomable {
//            ZStack {
//                LinearGradient(
//                    gradient:
//                        Gradient(
//                            colors: [
//                                .blue,
//                                .teal
//                            ]
//                        ),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//
//                TreeView(tree: $tree)
//                    .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
//                        LinesView(
//                            parentTree: self.tree,
//                            nodeCenters: nodeCenters
//                        )
//                    }
//                    .padding(.all, 200)
//            }
//        }
//        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
private struct ContentView: View {
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
private struct SubviewToTestWith: View {
    @Binding var isTapped: Bool

    var body: some View {
        Text(isTapped ? "Yo what?" : "Hello, World!")
            .bold(isTapped)
            .notifyViewTreeOnChanges(of: self)
        //            .renderViewTree(of: self)
    }
}
