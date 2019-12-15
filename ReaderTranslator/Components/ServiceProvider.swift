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

    @objc func service(
        _ pasteboard: NSPasteboard,
        userData _: String?,
        error: AutoreleasingUnsafeMutablePointer<NSString>
    ) {
        guard let text = pasteboard.string(forType: .string) else {
            error.pointee = errorMessage
            return
        }

        store.translateAction.add(.gTranslator(text: text))
        openText(text: text)
    }

    private func openText(text: String) {
        let defaultUrl = "https://translate.google.com"
        guard var urlComponent = URLComponents(string: defaultUrl) else { return }
        urlComponent.queryItems = [
            .init(name: "text", value: text)
        ]

        if let url = urlComponent.url { Safari.openSafari(url) }
    }
}
