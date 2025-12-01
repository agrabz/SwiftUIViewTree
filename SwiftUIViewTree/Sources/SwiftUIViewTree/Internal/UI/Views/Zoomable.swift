// Credit: https://github.com/Ceylo/Zoomable/tree/main

import UIKit
import SwiftUI

//TODO: bug with collapse, close, reopen, re-expand, scroll --> Zoomable doesn't update its boundaries. Workaround: close+reopen graph on expand/collapse
struct Zoomable<Content: View>: UIViewControllerRepresentable {
    private let host: UIHostingController<Content>
    private var changeToken: Int

    init(changeToken: Int, @ViewBuilder content: () -> Content) {
        print(#function)
        self.host = UIHostingController(rootView: content())
        self.changeToken = changeToken
    }

    func makeUIViewController(context: Context) -> ZoomableViewController {
        print(#function)
        return ZoomableViewController(
            view: self.host.view
        )
    }

    func updateUIViewController(_ uiViewController: ZoomableViewController, context: Context) {
        print(#function)
        uiViewController.contentView.removeFromSuperview()
        uiViewController.scrollView.removeFromSuperview()
        uiViewController.scrollView = UIScrollView()
        uiViewController.originalContentSize = self.host.view.intrinsicContentSize
        uiViewController.asd()
        uiViewController.qwe()
//        uiViewController.view.setNeedsLayout()
        uiViewController.view.layoutIfNeeded()
    }
}

final class ZoomableViewController : UIViewController, UIScrollViewDelegate {
    var scrollView = UIScrollView()
    var contentView: UIView
    var originalContentSize: CGSize
    private let zoomFloatingPointCalculationTolerance: CGFloat = 0.001
    private let zoomScaleFactorOnDoubleTap: CGFloat = 2.0

    init(view: UIView) {
        print(#function)
        self.scrollView.maximumZoomScale = 0.8
        self.contentView = view
        print(view.intrinsicContentSize)
        self.originalContentSize = view.intrinsicContentSize
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()


        asd()
    }

    func asd() {
        print(#function)
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
        print(#function)
        super.didMove(toParent: parent)
        guard parent != nil else { return }

        qwe()
    }

    func qwe() {
        print(#function)
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
        print(#function)
        super.viewDidLayoutSubviews()
        scrollView.minimumZoomScale = zoomScaleToFill(size: originalContentSize)
        asd()
        qwe()
        scrollToTheCenterHorizontallyAndToTheTopVertically()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print(#function)
        return contentView
    }
}

private extension ZoomableViewController {
    var currentZoomScale: CGFloat {
        print(#function)
        return scrollView.zoomScale
    }

    func zoomScaleToFill(size: CGSize) -> CGFloat {
        print(#function)
        let widthRatio = self.scrollView.frame.width / size.width
        let heightRatio = self.scrollView.frame.height / size.height
        return max(widthRatio, heightRatio)
    }

    @objc func doubleTap(sender: UITapGestureRecognizer) {
        print(#function)
        applySteppedZoom(sender: sender)
    }

    func applySteppedZoom(sender: UITapGestureRecognizer) {
        print(#function)
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
        print(#function)
        let canZoomInFurther = abs(proposedNextZoomScale - currentZoomScale) > zoomFloatingPointCalculationTolerance

        return canZoomInFurther
    }

    func zoomInAroundTapLocation(sender: UITapGestureRecognizer, targetZoomedInScale: CGFloat) {
        print(#function)
        let tapLocationInView = sender.location(in: contentView)
        zoom(to: tapLocationInView, zoomScale: targetZoomedInScale, animated: true)
    }

    func zoom(to tapLocationInView: CGPoint, zoomScale: CGFloat, animated: Bool) {
        print(#function)
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
        print(#function)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        scrollToTheCenterHorizontallyAndToTheTopVertically()
    }

    func scrollToTheCenterHorizontallyAndToTheTopVertically() {
        print(#function)
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
        print(#function)
        return min(
            max(value, lowerLimit),
            upperLimit
        )
    }
}
