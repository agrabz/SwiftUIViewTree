//
//  ConvertToTreesRecursively.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

func convertToTreesRecursively( //TODO: to test
    mirror: Mirror,
    maxDepth: Int = .max,
    currentDepth: Int = 0
) -> [Tree] {
    guard currentDepth < maxDepth else {
        return []
    }

    let result = mirror.children.map { child in
        let childMirror = Mirror(reflecting: child.value)




        var childTree = Tree(
            node: TreeNode(
                type: ShortenableString(fullString: "\(type(of: child.value))"),
                label: child.label ?? "<unknown>",
                value: ShortenableString(fullString: "\(child.value)"),
                displayStyle: String(describing: childMirror.displayStyle),
                subjectType: "\(childMirror.subjectType)",
                superclassMirror: String(describing: childMirror.superclassMirror),
                mirrorDescription: childMirror.description
            )
        ) // as Any? see type(of:) docs
        childTree.children = convertToTreesRecursively(
            mirror: Mirror(reflecting: child.value),
            maxDepth: maxDepth,
            currentDepth: currentDepth + 1
        )
        return childTree
    }
    return result
}
