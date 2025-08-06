//
//  NodeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct NodeView: View {
    let node: TreeNode

    var body: some View {
        VStack {
            Text(node.label)
                .font(.headline)
                .fontWeight(.black)

            HStack {
                Text(node.type.shortenedString)
                    .font(.caption)
                    .bold()
                Text(node.value.shortenedString)
                    .font(.caption)
                    .italic()
            }
            .padding(.all, 8)
            .background(Bool.random() ? .gray.opacity(0.2) : .purple)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 0.5)
            }
        }
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
