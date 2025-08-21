import SwiftUI

struct ScrollableZoomableTreeView: View {
    private static let minimumZoom: CGFloat = 0.1

    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = Self.minimumZoom
    @State var tree: Tree

    init(tree: Tree) {
        self._tree = State(initialValue: tree)

        print("Init: \(Date())")
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
        TreeView(tree: $tree)
            .backgroundPreferenceValue(NodeCenterPreferenceKey.self) { nodeCenters in
                LinesView(
                    parentTree: self.tree,
                    nodeCenters: nodeCenters
                )
            }
//            .frame(width: getRect().width - 30, height: getRect().height)
        //                .background(
        //                    LinearGradient(
        //                        gradient:
        //                            Gradient(
        //                                colors: [
        //                                    .blue,
        //                                    .teal
        //                                ]
        //                            ),
        //                        startPoint: .topLeading,
        //                        endPoint: .bottomTrailing
        //                    )
        //                )
            .addPinchZoom()
    }
        .onAppear {
            print("Appear: \(Date())")
        }
    }
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }

    func addPinchZoom() -> some View {
        PinchZoomContext {
            self
        }
    }
}

struct PinchZoomContext<Content: View>: View {
    var content: Content

//    @State var offset: CGPoint = .zero
    @State var scale: CGFloat = 0

    @State var scalePosition: CGPoint = .zero

    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
//            .offset(x: offset.x, y: offset.y)
            .overlay {
                GeometryReader { proxy in
                    ZoomGesture(
                        size: proxy.size,
                        scale: $scale,
//                        offset: $offset,
                        scalePosition: $scalePosition
                    )
                }
            }
            .scaleEffect(1 + scale, anchor: .init(x: scalePosition.x, y: scalePosition.y))
    }
}

struct ZoomGesture: UIViewRepresentable {

    var size: CGSize

    @Binding var scale: CGFloat
//    @Binding var offset: CGPoint

    @Binding var scalePosition: CGPoint

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let pinchGesture = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handlePinch(sender:))
        )
        view.addGestureRecognizer(pinchGesture)

//        let panGesture = UIPanGestureRecognizer(
//            target: context.coordinator,
//            action: #selector(context.coordinator.handlePan(sender:))
//        )
//
//        panGesture.delegate = context.coordinator
//
////        view.addGestureRecognizer(pinchGesture)
//        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: ZoomGesture

        init(parent: ZoomGesture) {
            self.parent = parent
        }

//        func gestureRecognizer(
//            _ gestureRecognizer: UIGestureRecognizer,
//            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
//        ) -> Bool {
//            true
//        }
//
//        @objc
//        func handlePan(sender: UIPanGestureRecognizer) {
//
//            sender.maximumNumberOfTouches = 2
//
//            if (sender.state == .began || sender.state == .changed) && parent.scale > 0 {
//                if let view = sender.view {
//                    let translation = sender.translation(in: view)
//
//                    parent.offset = translation
//                }
//            } else {
//                withAnimation {
//                    parent.offset = .zero
//                    parent.scalePosition = .zero
//                }
//            }
//        }

        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            if sender.state == .began || sender.state == .changed {
                parent.scale = sender.scale - 1

                let scalePoint = CGPoint(
                    x: sender.location(in: sender.view).x / sender.view!.frame.size.width, //TODO: Is this the key?
                    y: sender.location(in: sender.view).y / sender.view!.frame.size.height //TODO: Is this the key?
                )

                parent.scalePosition = parent.scalePosition == .zero ? scalePoint : parent.scalePosition
            }
//            } else {
//                withAnimation(.easeInOut(duration: 0.35)) {
////                    parent.scale = 0
////                    parent.scalePosition = .zero
//                }
//            }
        }
    }
}
