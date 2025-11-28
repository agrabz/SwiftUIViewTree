// Credit: https://github.com/Ceylo/Zoomable/tree/main

import UIKit
import SwiftUI

//TODO: still needed?
enum ZoomLevel {
    case fill
}

struct Zoomable<Content: View>: UIViewControllerRepresentable {
    private let host: UIHostingController<Content>
    private var initialZoomLevel: ZoomLevel = .fill
    private var primaryZoomLevel: ZoomLevel = .fill
    private var secondaryZoomLevel: ZoomLevel = .fill

    init(@ViewBuilder content: () -> Content) {
        self.host = UIHostingController(rootView: content())
    }

    func makeUIViewController(context: Context) -> ZoomableViewController {
        ZoomableViewController(
            view: self.host.view,
            initialZoomLevel: self.initialZoomLevel,
            primaryZoomLevel: self.primaryZoomLevel,
            secondaryZoomLevel: self.secondaryZoomLevel
        )
    }

    func updateUIViewController(_ uiViewController: ZoomableViewController, context: Context) {
        uiViewController.view.layoutIfNeeded()
    }
}

private extension Zoomable {
    func initialZoomLevel(_ zoomLevel: ZoomLevel) -> Self {
        var copy = self
        copy.initialZoomLevel = zoomLevel
        return copy
    }

    func primaryZoomLevel(_ zoomLevel: ZoomLevel) -> Self {
        var copy = self
        copy.primaryZoomLevel = zoomLevel
        return copy
    }

    func secondaryZoomLevel(_ zoomLevel: ZoomLevel) -> Self {
        var copy = self
        copy.secondaryZoomLevel = zoomLevel
        return copy
    }
}

//TODO: different file?
final class ZoomableViewController : UIViewController, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let contentView: UIView
    let originalContentSize: CGSize
    let initialZoomLevel: ZoomLevel
    let primaryZoomLevel: ZoomLevel
    let secondaryZoomLevel: ZoomLevel

    var initialScale: CGFloat {
        scale(for: initialZoomLevel)
    }

    var primaryScale: CGFloat {
        scale(for: primaryZoomLevel)
    }

    var secondaryScale: CGFloat {
        scale(for: secondaryZoomLevel)
    }

    init(
        view: UIView,
        initialZoomLevel: ZoomLevel,
        primaryZoomLevel: ZoomLevel,
        secondaryZoomLevel: ZoomLevel
    ) {
        self.scrollView.maximumZoomScale = 10
        self.contentView = view
        self.originalContentSize = view.intrinsicContentSize
        self.initialZoomLevel = initialZoomLevel
        self.primaryZoomLevel = primaryZoomLevel
        self.secondaryZoomLevel = secondaryZoomLevel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //TODO: smaller funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(gestureRecognizer)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    //TODO: smaller funcs
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent != nil else { return }

        let fillZoomLevel = zoomToFill(size: originalContentSize)
        scrollView.minimumZoomScale = fillZoomLevel

        scrollView.zoomScale = 1.0
        scrollView.contentSize = originalContentSize
        scrollView.zoomScale = fillZoomLevel

        Task {
            scrollView.setZoomScale(initialScale, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.minimumZoomScale = zoomToFill(size: originalContentSize)
        centerSmallContents()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerSmallContents()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
}

private extension ZoomableViewController {
    func centerSmallContents() {
        let contentSize = contentView.frame.size
        let offsetX = max((scrollView.bounds.width - contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

    func zoomToFill(size: CGSize) -> CGFloat {
        let widthRatio = self.scrollView.frame.width / size.width
        let heightRatio = self.scrollView.frame.height / size.height
        return max(widthRatio, heightRatio)
    }

    func scale(for zoomLevel: ZoomLevel) -> CGFloat {
        switch zoomLevel {
            case .fill:
                zoomToFill(size: originalContentSize)
        }
    }

    //TODO: review
    @objc func tap(sender: Any) {
        let currentScale = scrollView.zoomScale
        let inPrimaryScale = abs(currentScale - primaryScale) < 1e-3

        let newScale = max(scrollView.minimumZoomScale, inPrimaryScale ? secondaryScale : primaryScale)
        if currentScale != newScale {
            scrollView.setZoomScale(newScale, animated: true)
        }
    }
}

private extension CGSize {
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }
}
