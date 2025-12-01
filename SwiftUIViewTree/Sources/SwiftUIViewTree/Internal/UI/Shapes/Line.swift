import SwiftUI

struct Line: Shape {
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>

    var startPoint: CGPoint {
        CGPoint(
            x: animatableData.first.first,
            y: animatableData.first.second
        )
    }

    var endPoint: CGPoint {
        CGPoint(
            x: animatableData.second.first,
            y: animatableData.second.second
        )
    }

    init(startPoint: CGPoint, endPoint: CGPoint) {
        animatableData = AnimatablePair(
            AnimatablePair(startPoint.x, startPoint.y),
            AnimatablePair(endPoint.x, endPoint.y)
        )
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: startPoint)
            path.addQuadCurve(
                to: endPoint,
                control: CGPoint(
                    x: (startPoint.x + endPoint.x) / 2,
                    y: startPoint.y - 50
                )
            )
        }
    }
}
