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
            let start = startPoint
            let end = endPoint

            let yDistance = end.y - start.y

            path.move(to: start)
            path.addCurve(
                to: end,
                control1: CGPoint(
                    x: start.x,
                    y: start.y + abs(yDistance) * 0.5
                ),
                control2: CGPoint(
                    x: end.x,
                    y: end.y - abs(yDistance) * 0.3
                )
            )
        }
    }
}
