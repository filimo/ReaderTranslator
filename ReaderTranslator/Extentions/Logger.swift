//
//  Bundle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class Logger {
    static var appName: String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version: String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }

    static func debug(_ prefix: String, _ texts: String..., value: String? = nil) {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        let date = format.string(from: Date())

        let value = value != nil ? ": \(value!)" : ""

        let text = texts.joined(separator: ".")
        let message = "\(date) \(prefix) \(Logger.appName).\(text)\(value)"
        print(message)
    }
}
