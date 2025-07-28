//
//  Line.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 28..
//

import SwiftUI

struct Line: Shape {
    init(start: CGPoint, end: CGPoint) {
        animatableData = AnimatablePair(AnimatablePair(start.x, start.y), AnimatablePair(end.x, end.y))
    }
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>

    var start: CGPoint {
        CGPoint(
            x: animatableData.first.first,
            y: animatableData.first.second
        )
    }

    var end: CGPoint {
        CGPoint(
            x: animatableData.second.first,
            y: animatableData.second.second
        )
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}
