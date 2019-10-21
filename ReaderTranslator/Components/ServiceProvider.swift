//
//  File.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 21/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

class ServiceProvider: NSObject {
    @ObservedObject var store = Store.shared

    let errorMessage = NSString(string: "Could not find the text for parsing.")

    @objc func service(_ pasteboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        guard let text = pasteboard.string(forType: .string) else {
            error.pointee = errorMessage
            return
        }

        store.translateAction = .translator(text: text)
    }
}
