//
//  NodeView.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import SwiftUI

struct NodeView: View, Equatable {
    let node: String

    var body: some View {
        VStack {
            Text(node/*.label.prefix(20)*/)
                .font(.headline)
                .fontWeight(.black)

//            HStack {
//                Text(node/*.type*/.prefix(20))
//                    .font(.caption)
//                    .bold()
//                Text(node/*.value*/.prefix(20))
//                    .font(.caption)
//                    .italic()
//            }
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
