// Credit: https://github.com/Ceylo/Zoomable/tree/main

import UIKit
import SwiftUI

enum ZoomLevel {
    case fill
    case scale(CGFloat) // absolute scale factor relative to content’s original size
}

struct Zoomable<Content: View>: UIViewControllerRepresentable {
    private let host: UIHostingController<Content>
    private var initialZoomLevel: ZoomLevel = .fill
    private var primaryZoomLevel: ZoomLevel = .fill
    private var secondaryZoomLevel: ZoomLevel = .scale(2.0) // default to 2x

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
        // Clamp to maximumZoomScale to respect limits
        min(scale(for: secondaryZoomLevel), scrollView.maximumZoomScale)
    }

    init(
        view: UIView,
        initialZoomLevel: ZoomLevel,
        primaryZoomLevel: ZoomLevel,
        secondaryZoomLevel: ZoomLevel
    ) {
        self.scrollView.maximumZoomScale = 1
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

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
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
            return zoomToFill(size: originalContentSize)
        case .scale(let factor):
            // factor is relative to the fill scale so that .scale(2.0) means “2x the fit”
            return zoomToFill(size: originalContentSize) * factor
        }
    }

    @objc func doubleTap(sender: UITapGestureRecognizer) {
        let currentScale = scrollView.zoomScale
        let tolerance: CGFloat = 0.001
        let targetZoomedInScale = max(scrollView.minimumZoomScale, min(secondaryScale, scrollView.maximumZoomScale))
        let targetFitScale = max(scrollView.minimumZoomScale, min(primaryScale, scrollView.maximumZoomScale))

        let isCurrentlyZoomedIn = abs(currentScale - targetZoomedInScale) < tolerance || currentScale > targetFitScale + tolerance

        if isCurrentlyZoomedIn {
            // Zoom out to fit
            if currentScale != targetFitScale {
                scrollView.setZoomScale(targetFitScale, animated: true)
            }
        } else {
            // Zoom in around the tap location
            let locationInView = sender.location(in: contentView)
            zoom(to: locationInView, scale: targetZoomedInScale, animated: true)
        }
    }

    // Compute a rect centered at a point that results in the requested scale, then zoom to it.
    func zoom(to point: CGPoint, scale: CGFloat, animated: Bool) {
        // Desired visible size in content coordinates = scrollView.bounds.size / scale
        let size = CGSize(width: scrollView.bounds.width / scale, height: scrollView.bounds.height / scale)
        let origin = CGPoint(x: point.x - size.width / 2.0, y: point.y - size.height / 2.0)
        let rect = CGRect(origin: origin, size: size)
        scrollView.zoom(to: rect, animated: animated)
    }
}

private extension CGSize {
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }
}
