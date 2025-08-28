# Usage

Use `.renderViewTree(of: self)` to see the view tree visually next to your original view.

<img width="928" height="520" alt="image" src="https://github.com/user-attachments/assets/976b6d36-cfb3-49cd-be47-14454a160bb0" />

```swift
struct ContentView: View {
    @State var isTapped = false

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            Text(isTapped ? "Yo what?" : "Hello, world!")
                .font(.largeTitle)
                .bold(isTapped ? true : false)
        }
        .renderViewTree(of: self) //<------
    }
}
```

# Features

## Node color change on updates

If something got updated due to a state change it gets a new color:

![fixed-6](https://github.com/user-attachments/assets/211e8183-a862-4966-92b2-97ea98cd2acc)

![fixed-7](https://github.com/user-attachments/assets/55294e33-0915-4e3a-8de4-1ef5a17a4d92)

## Change printing to the console

And you can also see it in the console:

```
🚨Changes detected
"_value": "Bool"
🟥Old value: "false"
🟩New value: "true"
```

## Pinch to zoom and scroll

You can also pinch to zoom and scroll to any direction:

![SimulatorScreenRecording-iPhone16Pro-2025-08-22at16 18 24-ezgif com-rotate](https://github.com/user-attachments/assets/f436e600-1887-4dd1-8fa3-f3885f49d673)

## Collapse and re-expand

If certain parts of the tree are redundant for you, then you can double tap to collapse and later reopen them:

![fixed-5](https://github.com/user-attachments/assets/0c4ccb9a-e04f-4b03-aacf-43a4f1e523ad)

A collapsed node is always gray and a badge indicates how many direct children it has:

<img width="2622" height="1206" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-28 at 11 04 57" src="https://github.com/user-attachments/assets/457309b8-4b26-4a82-9f3a-c181ed502bad" />


## See full reflection details

You can tap on any node to print its full details.

```
Node Details:
    Label: _value
    Type: Bool
    Value: true
    DisplayStyle: nil
    SubjectType: Bool
    SuperclassMirror: nil
    mirrorDescription: Mirror for Bool
```

## Swift 6 Support

The solution is fully compatible with Swift 6.

# Why is this useful?

SwiftUI can produce unexpected updates that are hard to troubleshoot with the tools provided by Apple.

To troubleshoot and better understand the surprises of SwiftUI you might find this library useful.

There are numerous articles on the web that are about this topic. I'll collect some of my favorites and reference them here as the repository matures.

- [SWIFTUI THAT PAIN: REFRESH , REDRAWS, RESET— X — FILE](https://thexcodewhisperer.medium.com/swiftui-refresh-x-file-4502c98e00cd)

# Performance

The implementation uses Swift's reflection API ([Mirror](https://developer.apple.com/documentation/swift/mirror)) **recursively**.

While applying these view modifiers to your views might look attractive, it is important to be aware of its low performance with big views, however with small or medium views it should be okay. 

For the time being you can use the `maxDepth` input parameter


```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
                .bold()
        }
        .renderViewTree(of: self, maxDepth: 2) // indicating that you only want to see 2 levels instead of the full view tree
    }
}

```

# Roadmap

- Support for Swift Package Manager (SPM)

- Add licence

- Full unit test coverage

- Performance improvements, better UX with really big views.

- Closable, reopenable viewtree window

- Setable frame for the view tree

- Supporting `Any` type and not just `SwiftUI.View`

- Supporting logs for production usage

- Dedicated documentation page

- Explicit support for iPad and Mac.

- CI to run before every PR

# Alternatives

Probably the closest alternative is using SwiftUI's built-in, documented, but still private APIs:

```swift
let _ = Self._printChanges()
let _ = Self._logChanges()
```

As their name suggests, these APIs do not provide any UI, unlike this library.

Another alternative to figure out the exact type of a `SwiftUI.View` you can simply change the `some View` return type of the `body` computed variable to a definitely wrong type like `String`. 

With that you can see from the compiler error message the concrete type of your view. 

In the below example the (more) concrete type is `VStack<TupleView<(some View, Text)>>`

```swift
struct ContentView: View {
    var body: String { // Compiler error: Cannot convert return expression of type 'VStack<TupleView<(some View, Text)>>' to return type 'String'
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
                .bold()
        }
    }
}

```

This means that you can change the type of the `body` to `VStack<TupleView<(some View, Text)>>` and the compiler will be okay with that.

```swift
struct ContentView: View {
    var body: VStack<TupleView<(some View, Text)>> { // No error, this compiles
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
                .bold()
        }
    }
}

```

However you might already see the two limitations of this approach:
1. There's yet again a `some View` in the type, so you still don't know the concrete type.

What's worse is that figuring that out is not as straightforward as it was in the above example.

2. You don't see all the details that are made visible by this package. For example all the properties of the types.

# Support

If you face any problems, or have any feature request please feel free to open an Issue.

# Contribution

While I'm not new to open source development, I'm new to being the author of a library. Any help is welcome, please feel free to open PRs.

# Credits

This project is based on the work of Chris Eidhof (objc.io). In his 2019 Swiftable conference talk called "SwiftUI under the hood" ([link](https://www.youtube.com/watch?v=GuK6wwX8M0E)), he demoed a helper function which he called `.mirror()`. His mirror view modifier can be applied to any kind of SwiftUI View and will render its "viewtree" next to it:

<img width="1876" height="905" alt="image" src="https://github.com/user-attachments/assets/4605091a-bfaa-4ed1-b802-8297e39433ac" />

While his talk is not primarily about this helper function, it got the attention of many people as it seems to be a really promising debugging tool.

Additionally when I started to work on my implementation of his tool, I researched GitHub for any open source Swift projects for building graphs and I found [danielctull-playground/TreeView](https://github.com/danielctull-playground/TreeView) where the author describes the repository as "Implementation following the objc.io TreeView". 

I ended up using this repository's implementation with some tweaks, so I have to give the credits again to Chris and the whole objc.io team.
