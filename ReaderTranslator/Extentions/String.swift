//
//  String.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/26/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
}

extension String {
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension String {
    var cgFloatValue: CGFloat {
        if let width = NumberFormatter().number(from: self) {
            return CGFloat(width.floatValue)
        } else {
            return 0
        }
    }
    var intValue: Int {
        if let width = NumberFormatter().number(from: self) {
            return Int(width.intValue)
        } else {
            return 0
        }
    }
}
