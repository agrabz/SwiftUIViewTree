//
//  ViewTreeTraversalProgressView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct ViewTreeTraversalProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Traversing the view tree.")
                .font(.body)
                .bold()
            Text("It might take a while. If this takes too long, consider using `maxDepth`.")
                .font(.caption)
        }
    }
}
