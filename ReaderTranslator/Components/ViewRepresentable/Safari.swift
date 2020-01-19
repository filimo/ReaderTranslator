//
//  Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

struct Safari {
    private init() {}
}

#if os(OSX)
extension Safari {
    @discardableResult
    static func openSafari(_ url: URL) -> Bool {
        NSWorkspace.shared.open(url)
    }

    // TODO: implement keyCommands and performCommand
}

#elseif TARGET_IS_EXTENSION
extension Safari {
    static func openSafari(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
#else
extension Safari {
    static func openSafari(_ url: URL) {
    }
}
#endif

