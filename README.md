
# Intro & Credits

This project is based on the work of Chris Eidhof (objc.io). In his 2019 Swiftable conference talk called "SwiftUI under the hood" ([link](https://www.youtube.com/watch?v=GuK6wwX8M0E)), he demoed a helper function which he called `.mirror()`. His mirror view modifier can be applied to any kind of SwiftUI View and will render its "viewtree" next to it:

<img width="1876" height="905" alt="image" src="https://github.com/user-attachments/assets/4605091a-bfaa-4ed1-b802-8297e39433ac" />

While his talk is not primarily about this helper function, it got the attention of many people as it seems to be a really promising debugging tool.

Additionally when I started to work on my implementation of his tool, I researched GitHub for any open source Swift projects for building graphs and I found [danielctull-playground/TreeView](https://github.com/danielctull-playground/TreeView) where the author describes the repository as "Implementation following the objc.io TreeView". 

I ended up using this repository's implementation with some tweaks, so I have to give the credits again to Chris and the whole objc.io team.

# Usage

Add one of the two view modifiers of this package to any of your `SwiftUI.View`s to see its full or partial view tree.

Use `.renderViewTree()` to see the view tree visually.

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
        .renderViewTree() // <--
    }
}

```

<img width="928" height="520" alt="image" src="https://github.com/user-attachments/assets/5ddd7d00-3d5d-4b8d-af04-27a59d66d5d5" />

You can tap on any node to see its full details.

<img width="933" height="521" alt="image" src="https://github.com/user-attachments/assets/282fab37-fa9d-49a8-8f68-ebd8de46f61c" />

Or you can pitch to zoom and also scroll to any direction:

<img width="922" height="521" alt="image" src="https://github.com/user-attachments/assets/12101d48-bcc4-4311-8dde-7bc8a51e6e6b" />

<Gif 1>

Use `.printViewTree()` to see the view tree logged into the console.

<Image 4>

## Why is this useful?

One of the beauties of SwiftUI is that it hides the complexity of UI building from the developers, so one might ask "Why would I want to know the view tree of my view?"

If you dealt enough with SwiftUI you could see that it sometimes produces surprises. To troubleshoot or better understand these surprises you might find this library useful.

There are numerous articles on the web that are about this topic. I'll collect some of my favorites and reference them here as the repository matures.

## Performance

The implementation uses Swift's reflection API ([Mirror](https://developer.apple.com/documentation/swift/mirror)) **recursively**.

While applying these view modifiers to your views might look attractive, it is important to be aware of its low performance with big views. 

I'm working on its improvement, but it is suggested to use the `maxDepth` input parameter of both the `renderViewTree` and the `printViewTree` functions as below:


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
        .renderViewTree(maxDepth: 2) // indicating that you only want to see 2 levels instead of the full view tree
    }
}

```

<Image 5>

## Roadmap

- Support for Swift Package Manager (SPM)

- Add licence

- Full unit test coverage

- Performance improvements, better UX with big views

- Expandable nodes

- Closable, reopenable viewtree window

- Change detection between two view updates

- Setable frame for the view tree

- Supporting `Any` type and not just `SwiftUI.View` - that'll probably mean a repo name change as well

- Supporting logs for production usage

- Dedicated documentation page

## Alternatives

To figure out the exact type of a `SwiftUI.View` you can simply change the `some View` return type of the `body` computed variable to a definitely wrong type like `String`. 

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

## Support

If you face any problems, or have any feature request please feel free to open an Issue.

## Contribution

While I'm not new to open source development, I'm new to being the author of a library. Any help is welcome, please feel free to open PRs.
