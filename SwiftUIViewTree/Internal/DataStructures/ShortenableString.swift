//
//  ShortenableString.swift
//  SwiftUIViewTree
//
//  Created by Grabecz, Akos on 2025. 07. 29..
//

import Observation

//@Observable
//final class ShortenableString: Equatable {
//    let fullString: String
//    @ObservationIgnored var maxLength = 20
//
//    @ObservationIgnored
//    var shortenedString: String {
//        if fullString.count <= maxLength {
//            fullString
//        } else {
//            String(fullString.prefix(maxLength)) + "..."
//        }
//    }
//
//    init(fullString: String, maxLength: Int = 20) {
//        self.fullString = fullString
//        self.maxLength = maxLength
//    }
//
//    static func == (lhs: ShortenableString, rhs: ShortenableString) -> Bool {
//        lhs.fullString == rhs.fullString &&
//        lhs.maxLength == rhs.maxLength
//    }
//}
