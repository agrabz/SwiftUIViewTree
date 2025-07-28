//
//  KeyPath+Extensions.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

extension KeyPath {
    func callAsFunction(_ root: Root) -> Value { root[keyPath: self] }
}

func +<A, B, C>(
    lhs: KeyPath<A, B>,
    rhs: KeyPath<B, C>
) -> KeyPath<A, C> {
    lhs.appending(path: rhs)
}
