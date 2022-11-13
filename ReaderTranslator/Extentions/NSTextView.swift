//
//  NSTextView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 13.11.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import AppKit

extension NSTextView {
    var selectedText: String {
        var text = ""
        for case let range as NSRange in self.selectedRanges {
            text.append(string[range] + "\n")
        }
        text = String(text.dropLast())
        return text
    }
}

extension String {
    subscript(_ range: NSRange) -> Self {
        .init(self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)])
    }
}
