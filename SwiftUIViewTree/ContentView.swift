//
//  ContentView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            .font(.largeTitle)
//            .bold()
//        VStack {
//            if false {
//                Text("Hello, 2!")
//            } else {
//                Text("Hello, 4!")
//            }
//        }
        Text("Reset")
            .background(Color.blue)
//                .printViewTree()
                .renderViewTree()
//            .bold()
//        }
//        .padding()
    }
}

#Preview {
    ContentView()
}

extension Mirror {
    func printRecursively() {
        if children.isEmpty {
            print("end of branch of \(self)")
            return
        }
        print("Ákos description", self.subjectType)
        for (idx, child) in children.enumerated() {
            let label = child.label
            let value = child.value
            print(
                "|_ Ákos",
                idx,
                "\(type(of: value))",
                label ?? "<unknown>",
                value,
                separator: " | "
            )

            print("Checking children of \(Mirror(reflecting: value))")
            Mirror(reflecting: value)
                .printRecursively()
        }
    }
}


func convertChildrenToTreesRecursively(mirror: Mirror, maxDepth: Int = .max, currentDepth: Int = 0) -> [Tree] {
    guard currentDepth < maxDepth else {
        return []
    }

    let result = mirror.children.map { child in
        var childTree = Tree(
            node: TreeNode(
                type: "\(type(of: child.value))",
                label: child.label ?? "<unknown>",
                value: "\(child.value)"
            )
        ) // as Any? see type(of:) docs
        childTree.children = convertChildrenToTreesRecursively(
            mirror: Mirror(reflecting: child.value),
            maxDepth: maxDepth,
            currentDepth: currentDepth + 1
        )
        return childTree
    }
    return result
}

public extension View {
    func printViewTree() -> some View {
        print("Ákos")
        Mirror(reflecting: self).printRecursively()
        return self
    }


    func renderViewTree() -> some View {
        let mirror = Mirror(reflecting: self)
        var tree = Tree(
            node: TreeNode(
                type: "Root node",
                label: "Root node",
                value: "Root node"
            )
        )
        tree.children = convertChildrenToTreesRecursively(
            mirror: mirror,
//            maxDepth: 2
        )

        return HStack {
            self

            Spacer()

            NavigationStack {
                TreeView(tree: tree) { value in
                        Text(value)
                            .background()
                            .padding()
                    }
                    .background(Color.yellow)
            }
        }
    }
}

struct TreeNode {
    let type: String
    let label: String
    let value: String
}

struct Tree {
    let id: UUID = UUID()
    let node: TreeNode
    var children: [Tree]

    init(
        node: TreeNode,
        children: [Tree] = []
    ) {
        self.node = node
        self.children = children
    }
}

struct TreeView<Content: View>: View {

    fileprivate let tree: Tree
//    fileprivate let id: KeyPath<String, ID>
    fileprivate let content: (String) -> Content

    public init(
        tree: Tree,
//        id: KeyPath<String, ID>,
        content: @escaping (String) -> Content
    ) {
        self.tree = tree
//        self.id = id
        self.content = content
    }

    public var body: some View {
        ItemsView(
            tree: tree,
            content: content
        )
            .backgroundPreferenceValue(CenterKey.self) {
                LinesView(
                    tree: self.tree,
                    centers: $0
                )
            }
    }
}

fileprivate struct LinesView: View {

    let tree: Tree
//    let id: KeyPath<String, ID>
    let centers: [UUID: Anchor<CGPoint>]

    private func point(for value: UUID, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = centers[tree.id] else {
            print("problem here", #line)
            return nil
        }
        return proxy[anchor]
    }

    private func line(to child: Tree, in proxy: GeometryProxy) -> Line? {
        guard let start = point(for: tree.id, in: proxy) else {
            print("problem here", #line)
            return nil
        }
        guard let end = point(for: child.id, in: proxy) else {
            print("problem here", #line)
            return nil
        }
        return Line(start: start, end: end)
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(self.tree.children, id: \.id) { child in
                Group {
                    self.line(to: child, in: proxy)?
                        .stroke()
                    LinesView(tree: child, centers: self.centers)
                }
            }
        }
    }
}

fileprivate struct Line: Shape {

    init(start: CGPoint, end: CGPoint) {
        animatableData = AnimatablePair(AnimatablePair(start.x, start.y), AnimatablePair(end.x, end.y))
    }

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>
    var start: CGPoint { CGPoint(x: animatableData.first.first, y: animatableData.first.second) }
    var end: CGPoint { CGPoint(x: animatableData.second.first, y: animatableData.second.second) }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}

fileprivate struct ItemsView<Content: View>: View {

    let tree: Tree
//    let id: KeyPath<String, ID>
//    let id: UUID
    let content: (String) -> Content
    @State private var isPopoverPresented = false

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            VStack {
                Button {
                    isPopoverPresented.toggle()
                } label: {
                    content(tree.node.type)
                        .anchorPreference(key: CenterKey.self, value: .center) { anchor in
                            [tree.id: anchor]
                        }
                }
                .popover(isPresented: $isPopoverPresented) {
                    ScrollView([.vertical, .horizontal]) {
                        VStack(alignment: .leading) {
                            Text("Type: \(tree.node.type)")
                            Text("Label: \(tree.node.label)")
                            Text("Value: \(tree.node.value)")
                        }
                        .padding(.horizontal)
                    }
                    .presentationCompactAdaptation(.popover)
                }
                HStack(alignment: .top) {
                    ForEach(tree.children, id: \Tree.id) { child in
                        ItemsView(
                            tree: child,
                            content: self.content
                        )
                    }
                }
            }
        }
    }
}

//extension KeyPath {
//    func callAsFunction(_ root: Root) -> Value { root[keyPath: self] }
//}
//
//fileprivate func +<A, B, C>(
//    lhs: KeyPath<A, B>,
//    rhs: KeyPath<B, C>
//) -> KeyPath<A, C> {
//    lhs.appending(path: rhs)
//}

fileprivate struct CenterKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: Anchor<CGPoint>] { [:] }
    static func reduce(value: inout [ID: Anchor<CGPoint>], nextValue: () -> [ID: Anchor<CGPoint>]) {
        value = value.merging(nextValue(), uniquingKeysWith: { $1 })
    }
}
