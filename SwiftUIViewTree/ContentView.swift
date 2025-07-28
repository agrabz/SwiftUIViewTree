//
//  ContentView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
                .bold()
                .printViewTree()
                .renderViewTree()
        }
    }
}

#Preview {
    ContentView()
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
