//
//  ShortenableString.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

struct ShortenableString {
    let fullString: String
    var maxLength: Int = 30

    var shortenedString: String {
        if fullString.count <= maxLength {
            fullString
        } else {
            String(fullString.prefix(maxLength)) + "..."
        }
    }
}
