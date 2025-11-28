// Credit: https://github.com/Ceylo/Zoomable/tree/main

import UIKit
import SwiftUI

struct Zoomable<Content: View>: UIViewControllerRepresentable {
    private let host: UIHostingController<Content>

    init(@ViewBuilder content: () -> Content) {
        self.host = UIHostingController(rootView: content())
    }

    func makeUIViewController(context: Context) -> ZoomableViewController {
        ZoomableViewController(
            view: self.host.view
        )
    }

    func updateUIViewController(_ uiViewController: ZoomableViewController, context: Context) {
        uiViewController.view.layoutIfNeeded()
    }
}

final class ZoomableViewController : UIViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let contentView: UIView
    private let originalContentSize: CGSize
    private let zoomCalculationTolerance: CGFloat = 0.001
    private let zoomScaleFactorOnDoubleTap: CGFloat = 2.0

    init(view: UIView) {
        self.scrollView.maximumZoomScale = 0.8
        self.contentView = view
        self.originalContentSize = view.intrinsicContentSize
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

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent != nil else { return }

        let fillZoomLevel = zoomScaleToFill(size: originalContentSize)
        scrollView.minimumZoomScale = fillZoomLevel

        scrollView.zoomScale = 1.0
        scrollView.contentSize = originalContentSize
        scrollView.zoomScale = fillZoomLevel

        Task { @MainActor in
            scrollView.setZoomScale(fillZoomLevel, animated: true)
            scrollToTheCenterHorizontallyAndToTheTopVertically()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.minimumZoomScale = zoomScaleToFill(size: originalContentSize)
        scrollToTheCenterHorizontallyAndToTheTopVertically()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
}

private extension ZoomableViewController {
    var currentZoomScale: CGFloat {
        scrollView.zoomScale
    }

    func zoomScaleToFill(size: CGSize) -> CGFloat {
        let widthRatio = self.scrollView.frame.width / size.width
        let heightRatio = self.scrollView.frame.height / size.height
        return max(widthRatio, heightRatio)
    }

    @objc func doubleTap(sender: UITapGestureRecognizer) {
        applySteppedZoom(sender: sender)
    }

    func applySteppedZoom(sender: UITapGestureRecognizer) {
        let proposedNextZoomScale = min(currentZoomScale * zoomScaleFactorOnDoubleTap, scrollView.maximumZoomScale)

        if canZoomIn(toZoomScale: proposedNextZoomScale) {
            zoomInAroundTapLocation(
                sender: sender,
                targetZoomedInScale: proposedNextZoomScale
            )
        } else {
            zoomOutFully()
        }
    }

    func canZoomIn(
        toZoomScale proposedNextZoomScale: CGFloat
    ) -> Bool {
        let canZoomInFurther = abs(proposedNextZoomScale - currentZoomScale) > zoomCalculationTolerance

        return canZoomInFurther
    }

    func zoomInAroundTapLocation(sender: UITapGestureRecognizer, targetZoomedInScale: CGFloat) {
        let tapLocationInView = sender.location(in: contentView)
        zoom(to: tapLocationInView, zoomScale: targetZoomedInScale, animated: true)
    }

    func zoom(to tapLocationInView: CGPoint, zoomScale: CGFloat, animated: Bool) {
        let desiredVisibleWidthInContentCoordinates = scrollView.bounds.width / zoomScale
        let desiredVisibleHeightInContentCoordinates = scrollView.bounds.height / zoomScale
        let size = CGSize(
            width: desiredVisibleWidthInContentCoordinates,
            height: desiredVisibleHeightInContentCoordinates
        )

        let origin = CGPoint(
            x: tapLocationInView.x - size.width / zoomScaleFactorOnDoubleTap,
            y: tapLocationInView.y - size.height / zoomScaleFactorOnDoubleTap
        )

        let rect = CGRect(origin: origin, size: size)

        scrollView.zoom(to: rect, animated: animated)
    }

    func zoomOutFully() {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        scrollToTheCenterHorizontallyAndToTheTopVertically()
    }

    func scrollToTheCenterHorizontallyAndToTheTopVertically() {
        let contentSize = scrollView.contentSize
        let boundsSize = scrollView.bounds.size

        guard
            boundsSize.width > 0,
            boundsSize.height > 0
        else {
            return
        }

        let maxOffsetX = max(contentSize.width - boundsSize.width, 0)
        let centeredX = maxOffsetX / 2.0

        let maxOffsetY = max(contentSize.height - boundsSize.height, 0)
        let topY: CGFloat = 0

        let target = CGPoint(
            x: clamp(centeredX, lowerLimit: 0, upperLimit: maxOffsetX),
            y: clamp(topY, lowerLimit: 0, upperLimit: maxOffsetY)
        )

        scrollView.setContentOffset(target, animated: false)
    }

    func clamp(_ value: CGFloat, lowerLimit: CGFloat, upperLimit: CGFloat) -> CGFloat {
        return min(
            max(value, lowerLimit),
            upperLimit
        )
    }
}

private extension CGSize {
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }
}
