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
            if true {
                Text("Hello, 2!")
            } else {
                Text("Hello, 3!")
            }
        }
                .debug()
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
    func debug() -> some View {
        print("Ákos")
        //        print(body)
        Mirror(reflecting: self).printRecursively()
        return self
    }
}
