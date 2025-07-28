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
        VStack {
            if false {
                Text("Hello, 2!")
            } else {
                Text("Hello, 3!")
//                TreeView(
//                    tree: Tree(
//                        value: "Parent",
//                        children: [
//                            Tree(
//                                value: "Child1",
//                            ),
//                            Tree(
//                                value: "Child2",
//                                children: [
//                                    Tree(
//                                        value: "Grandchild"
//                                    )
//                                ]
//                            ),
//                        ]
//                    ),
//                    id: \.self) { value in
//                        Text(value)
//                            .background()
//                            .padding()
//                    }
            }
        }
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
            let label = child.label ?? "<unknown>"
            let value = child.value
            print(
                "|_ Ákos",
                idx,
                "\(type(of: value))",
//                label,
//                value,
                separator: " | "
            )

            Mirror(reflecting: value)
                .printRecursively()
        }
    }
}

public extension View {
    func renderViewTree() -> some View {
        print("Ákos")
        //        print(body)
        let mirror = Mirror(reflecting: self)
        var tree = Tree(value: mirror.description)
        tree.children = mirror.children.map { child in
            Tree(value: "\(type(of: child.value))")
        }
//        Mirror(reflecting: self).printRecursively()
        return HStack {
            self

            Spacer()

            TreeView(
                tree: tree,
                id: \.self) { value in
                    Text(value)
                        .background()
                        .padding()
                }
                .background(Color.yellow)
        }
    }
}


public struct Tree {
    public let value: String
    public var children: [Tree]

    public init(value: String, children: [Tree] = []) {
        self.value = value
        self.children = children
    }
}

public struct TreeView<ID: Hashable, Content: View>: View {

    fileprivate let tree: Tree
    fileprivate let id: KeyPath<String, ID>
    fileprivate let content: (String) -> Content

    public init(tree: Tree,
                id: KeyPath<String, ID>,
                content: @escaping (String) -> Content) {
        self.tree = tree
        self.id = id
        self.content = content
    }

    public var body: some View {
        ItemsView(tree: tree, id: id, content: content)
            .backgroundPreferenceValue(CenterKey.self) {
                LinesView(tree: self.tree, id: self.id, centers: $0)
            }
    }
}

fileprivate struct LinesView<ID: Hashable>: View {

    let tree: Tree
    let id: KeyPath<String, ID>
    let centers: [ID: Anchor<CGPoint>]

    private func point(for value: String, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = centers[id(value)] else { return nil }
        return proxy[anchor]
    }

    private func line(to child: Tree, in proxy: GeometryProxy) -> Line? {
        guard let start = point(for: tree.value, in: proxy) else { return nil }
        guard let end = point(for: child.value, in: proxy) else { return nil }
        return Line(start: start, end: end)
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(self.tree.children, id: \Tree.value + self.id) { child in
                Group {
                    self.line(to: child, in: proxy)?
                        .stroke()
                    LinesView(tree: child, id: self.id, centers: self.centers)
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

fileprivate struct ItemsView<ID: Hashable, Content: View>: View {

    let tree: Tree
    let id: KeyPath<String, ID>
    let content: (String) -> Content

    var body: some View {
        VStack {
            content(tree.value)
                .anchorPreference(key: CenterKey.self, value: .center) { anchor in
                    [self.tree.value[keyPath: self.id]: anchor]
                }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \Tree.value + self.id) { child in
                    ItemsView(tree: child, id: self.id, content: self.content)
                }
            }
        }
    }
}

extension KeyPath {
    func callAsFunction(_ root: Root) -> Value { root[keyPath: self] }
}

fileprivate func +<A, B, C>(
    lhs: KeyPath<A, B>,
    rhs: KeyPath<B, C>
) -> KeyPath<A, C> {
    lhs.appending(path: rhs)
}

fileprivate struct CenterKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: Anchor<CGPoint>] { [:] }
    static func reduce(value: inout [ID: Anchor<CGPoint>], nextValue: () -> [ID: Anchor<CGPoint>]) { //swiftlint:disable:this just_return
        value = value.merging(nextValue(), uniquingKeysWith: { $1 })
    }
}
