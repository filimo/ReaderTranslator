//
//  OpenPanel.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 23/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

class OpenPanel {
    static func showChooseFileDialog(
        title: String,
        allowedFileTypes: [UTType],
        onFinished: @escaping (_: URL?) -> Void
    ) {
        let openPanel = NSOpenPanel()

        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.title = title
        openPanel.allowedContentTypes = allowedFileTypes

        openPanel.begin { result in
            if result == .OK {
                onFinished(openPanel.url)
            } else {
                onFinished(nil)
            }
        }
    }
}
