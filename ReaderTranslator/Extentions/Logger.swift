//
//  Bundle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import os.log
import Foundation

final class Logger {
    static func debug(
        log: OSLog,
        className: AnyClass? = nil,
        callback: String = "",
        delegate: String = "",
        value: Any? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
        ) {

        let file = file.replacingOccurrences(
            of: "/Users/filimo/MyProjects/ReaderTranslator/ReaderTranslator/",
            with: "")
        let callback = callback.isEmpty ? "" : ".\(callback)"
        let delegate = delegate.isEmpty ? "" : ".\(delegate)"
        let className = className == nil ? "" : String(describing: className!)
        let value = value == nil ? "" : ": \(String(describing: value!))"

        os_log("%s:%i %s%s%s.%s%s", log: log, type: .debug,
               file, line, className, delegate, callback, function, value)
    }
}
