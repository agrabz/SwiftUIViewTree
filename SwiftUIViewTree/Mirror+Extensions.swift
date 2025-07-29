//
//  Mirror+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

extension Mirror {
    func printRecursively() {
        if children.isEmpty {
            print("end of branch of \(self)")
            return
        }
        for (idx, child) in children.enumerated() {
            let label = child.label
            let value = child.value
            print(
                "|_ \(idx)",
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
