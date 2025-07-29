//
//  NodeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct NodeView: View {
    let value: String

    var body: some View {
        Text(value)
            .padding(.all, 8)
            .background(.white)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 0.5)
            }
            .padding(.all, 8)
    }
}
