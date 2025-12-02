
@MainActor
enum SubtreeMatcher {
    //TODO: Right now we cannot properly differentiate between subviews that are the same, so we always return the first match. Later it should be adjusted with a @State UUID approach like .notifyViewTreeOnChanges(of: self, id: $id)
    static func findMatchingSubTree(in root: Tree, matching target: Tree) -> SubTree? {
        var queue: [Tree] = [root]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if current == target {
                return SubTree(
                    changedSubTree: current,
                    originalSubTree: target
                )
            }

            queue.append(contentsOf: current.children)
        }

        return nil
    }

    static func replaceMatchingSubTree(with tree: Tree, matching target: Tree, in root: Tree) -> Tree? {
        print()
        print(target)
        print()
        for (index, child) in root.children.enumerated() {
            print()
            print(index, child)
            print()
            if child == target {
                root.children[index] = tree
                return root
            } else {
                return replaceMatchingSubTree(
                    with: tree,
                    matching: target,
                    in: child
                )
            }
        }

        return nil
    }

/// Not found due to the below two are really hard to match:
///
///(1) _isTapped: Binding<Bool> = Binding<Bool>(transaction: SwiftUI.Transaction(plist: []), location: SwiftUIViewTree.location
///-- (2) transaction: Transaction = Transaction(plist: [])
///-- (3) plist: PropertyList = []
///-- (4) elements: Optional<Element> = nil
///-- (5) SwiftUIViewTree.location: SwiftUIViewTree.location = SwiftUIViewTree.location
///-- (6) _value: Bool = false
///
///0 (1) _isTapped: State<Bool> = State<Bool>(_value: false, _location: SwiftUIViewTree.location
///-- (2) _value: Bool = false
///-- (3) _location: Optional<AnyLocation<Bool>> = Optional(SwiftUI.StoredLocation<Swift.Bool>)
///-- (4) some: StoredLocation<Bool> = SwiftUI.StoredLocation<Swift.Bool>
///-- (5) host: Optional<GraphHost> = Optional(SwiftUI.GraphHost)
///-- (6) some: ViewGraph = SwiftUI.GraphHost
///-- (7) _signal: WeakAttribute<()> = #6856
///-- (8) base: AGWeakAttribute = #6856
///-- (9) _details: __Unnamed_struct__details = __Unnamed_struct__details(identifier: #6856, seed: 5)
///-- (10) identifier: AGAttribute = #6856
///-- (11) rawValue: UInt32 = 6856
///-- (12) seed: UInt32 = 5

}
