
import Foundation
import UIKit

@Observable
@MainActor
final class OrientationInfo {
    enum Orientation {
        case portrait
        case landscape
    }

    private static let shared = OrientationInfo()

    static var isLandscape: Bool {
        shared.orientation == .landscape
    }

    static var isPortrait: Bool {
        !isLandscape
    }

    private var orientation: Orientation

    @ObservationIgnored
    private var _observer: NSObjectProtocol?

    private init() {
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        } else {
            self.orientation = .portrait
        }

        self.setupObserver()
    }

    isolated deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

private extension OrientationInfo {
    func setupObserver() {
        self._observer = NotificationCenter.default
            .addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] notification in
                guard
                    let self,
                    let device = notification.object as? UIDevice
                else {
                    return
                }

                Task { @MainActor in
                    if device.orientation.isPortrait {
                        self.orientation = .portrait
                    } else if device.orientation.isLandscape {
                        self.orientation = .landscape
                    }
                }
            }
    }
}
