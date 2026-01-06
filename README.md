![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/agrabz/SwiftUIViewTree)

# Usage

Use `.renderViewTree(of: self)` to see the view tree visually next to your original view.

<img width="400" height="798" alt="RocketSim_Screenshot_iPhone_17_Pro_6 3_2026-01-05_14 57 07" src="https://github.com/user-attachments/assets/9aff19a0-0192-443a-aaa4-41b846290a95" />

<img width="350" height="698" alt="RocketSim_Screenshot_iPhone_17_Pro_6 3_2026-01-05_14 57 21" src="https://github.com/user-attachments/assets/726dc51d-bff5-4eee-b967-cefe68efaaf3" />

The screenshots above is produced by the code below:

```swift
import SwiftUIViewTree

struct ContentView: View {
    @State var isTapped = false

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(isTapped ? "Yo what?" : "Hello, world!")
                    .bold(isTapped ? true : false)
            }
            .padding()
        }
        .renderViewTree(of: self) // <--------
    }
}
```

Without the `.renderViewTree(of: self)` line the view would be just like:

<img width="524.4" height="241.2" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-29 at 10 57 40" src="https://github.com/user-attachments/assets/31dfc7c4-ed70-4442-b0a7-984808b74607" />

# Features

## Pinch to zoom and scroll

You can also pinch to zoom and scroll to any direction.

Tip: Use `Option` + `Shift` to move both fingers on a simulator.

![fixed-gif](https://github.com/user-attachments/assets/0fb0b4b3-0a1f-4ce9-9a81-4ea78c1828d1)


## Double tap to zoom

You can apply stepped zoom by double tapping on the view tree's canvas.

![fixed-gif2](https://github.com/user-attachments/assets/1471323f-7ff1-4a15-99fb-b52423c64124)


## Node color change on updates

If something got updated due to a state change it gets a new color:

![fixed-gif2](https://github.com/user-attachments/assets/1067937a-01b0-4ba1-9eae-d0a2723bf7e2)



## Change Detection | Printing to the console

When a node gets a new color you can also see it in the console:

```
🚨Changes detected in "_value": "Bool"
🟥Old value: "true"
🟩New value: "false"
🔺Diff at [0]: '...true...' --> '...false...'
```

## Double tap a node to Collapse/ Expand

If certain parts of the tree are redundant for you, then you can double tap to collapse and later reopen them:

![fixed-gif3](https://github.com/user-attachments/assets/437f22c1-a183-4b3d-8a78-fc9cbeb8081b)

A collapsed node is always gray and a badge indicates how many descendants it has:

<img width="400" height="798" alt="RocketSim_Screenshot_iPhone_17_Pro_6 3_2026-01-05_15 47 08" src="https://github.com/user-attachments/assets/9c3a9437-d9bd-4c39-875d-680f6c930639" />


## Tap a node to see full details

You might not want to zoom in always to see the details of a specific node. 
In that case you can tap on any node to print its full details.

```
Node Details:
    Label: _value
    Type: Bool
    Value: true
```

## Swift 6 Support

The solution is fully compatible with Swift 6.

## iPad Support

You can browse the view tree on an iPad as well.

<img width="400" height="517" alt="RocketSim_Screenshot_iPad_Air_13-inch_(M3)_12 9_2026-01-05_14 57 56" src="https://github.com/user-attachments/assets/9b9c6691-74c7-4f5a-8b60-1828540b8b25" />

<img width="517" height="400" alt="RocketSim_Screenshot_iPad_Air_13-inch_(M3)_12 9_2026-01-05_14 56 18" src="https://github.com/user-attachments/assets/26304d2b-2c96-41d0-95bd-03e6a6cf8659" />

# Why is this useful?

SwiftUI can produce unexpected updates that are not easy to troubleshoot with the built-in tools.

To troubleshoot and better understand the surprises of SwiftUI you might find this library useful.

There are numerous articles on the web that are about this topic. I'll collect some of my favorites and reference them here as the repository matures.

- [SWIFTUI THAT PAIN: REFRESH , REDRAWS, RESET— X — FILE](https://thexcodewhisperer.medium.com/swiftui-refresh-x-file-4502c98e00cd)

# Roadmap

- Add history of graph state to be able to track quick changes e.g. image blinking.

- Detach view tree from source to stop receiving new updates

- Setable frame for the view tree

- Tapping on a connection line to scroll to the parent node

- Better accessibility support, maybe with the usage of `OutlineGroup` as `renderMode`

- Supporting logs for production usage

- Dedicated documentation page

- Support for Mac

- CI on PRs

- Build a table in the documentation of tested view types - maybe

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
