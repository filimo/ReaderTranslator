//
//  Clipboard.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 18/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

#if os(macOS)
import AppKit

struct Clipboard {
    static var string: String {
        NSPasteboard.general.string(forType: .string) ?? ""
    }

    
    static func copy(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}
#else
import UIKit

struct Clipboard {
    static var string: String {
        return UIPasteboard.general.string ?? ""
    }
    
    static func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
#endif
