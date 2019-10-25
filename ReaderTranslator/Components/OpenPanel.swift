//
//  OpenPanel.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 23/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AppKit
import SwiftUI

class OpenPanel {
    static func showChooseFileDialog(
        title: String,
        allowedFileTypes: [String],
        onFinished: @escaping (_: String?) -> Void) {

        let openPanel = NSOpenPanel()

        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.title = title
        openPanel.allowedFileTypes = allowedFileTypes

        openPanel.begin { result -> Void in
            if result == .OK {
                onFinished(openPanel.url?.absoluteString ?? "")
            } else {
                onFinished("")
            }
        }
    }
}
