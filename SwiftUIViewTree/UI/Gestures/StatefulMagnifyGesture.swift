//
//  StatefulMagnifyGesture.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct StatefulMagnifyGesture: Gesture {
    @Binding var currentZoom: CGFloat
    @Binding var totalZoom: CGFloat

    var body: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                currentZoom = value.magnification - 1
            }
            .onEnded { value in
                totalZoom += currentZoom
                currentZoom = 0
            }
    }
}
