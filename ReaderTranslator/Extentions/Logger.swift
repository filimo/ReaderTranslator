//
//  Bundle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import os.log
import Foundation

var PREVIEW_MODE: Bool = false

final class Logger {
    static func log(
        log: OSLog = .default,
        type: OSLogType = .error,
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

        os_log("%s:%i %s%s%s.%s%s", log: log, type: type,
               file, line, className, delegate, callback, function, value)
    }
}

// MARK: - ❌ DEBUG RELATED

/** short and beautiful print */
func pp(_ object: Any?) {
    #if DEBUG
        if let object = object {
            pp("⚪️ \(object)")
        } else {
            pp("⚪️ \(String(describing: object))")
        }
    #endif
}

func pp(_ text: String, terminator: String? = nil) {
    #if DEBUG
        terminator == nil ? print(text) : print(text, terminator: terminator!)
    #endif
}

func warn(_ text: String) { pp("⚠️ " + text) }

func err(_ text: String, type: Swift.Error = NonFatal.ErrorWithMessage) { pp("❌ " + text) }

enum NonFatal: Error { case ErrorWithMessage }

func pp<T>(
    object: Any?,

    className: T.Type,
    callback: String = "",
    delegate: String = "",
    value: Any? = nil,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    #if DEBUG
        if let object = object {
            pp(
                "⚪️ \(object)",

                className: T.self,
                callback: callback,
                delegate: delegate,
                value: value,
                file: file,
                line: line,
                function: function
            )
        } else {
            pp("⚪️ \(String(describing: object))", className: className)
        }
    #endif
}

func pp<T>(
    log: OSLog = .default,
    type: OSLogType = .default,

    _ text: String,
    terminator: String? = nil,

    className: T.Type,
    callback: String = "",
    delegate: String = "",
    value: Any? = nil,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    #if DEBUG
        if ProcessInfo().environment["LOGGER_EXTRA_LEVEL"] == "1" {
            let file = file.components(separatedBy: "/ios/Tripster/").last!
            let callback = callback.isEmpty ? "" : ".\(callback)"
            let delegate = delegate.isEmpty ? "" : ".\(delegate)"
            let className = String(describing: className)
            let value = value == nil ? "" : ": \(String(describing: value!))"

            os_log(
                "\n\n%s:%i\n%s%s%s.%s%s\n%s%s",
                log: log,
                type: type,
                file,
                line,
                className,
                delegate,
                callback,
                function,
                value,
                text,
                terminator ?? ""
            )
        } else {
            terminator == nil ? print(text) : print(text, terminator: terminator!)
        }

    #endif
}

func warn<T>(
    _ text: String,

    className: T.Type,
    callback: String = "",
    delegate: String = "",
    value: Any? = nil,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    pp(
        type: .info, "⚠️ " + text,

        className: T.self,
        callback: callback,
        delegate: delegate,
        value: value,
        file: file,
        line: line,
        function: function
    )
}

func err<T>(
    _ text: String,
    type _: Swift.Error = NonFatal.ErrorWithMessage,

    className: T.Type,
    callback: String = "",
    delegate: String = "",
    value: Any? = nil,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    pp(
        type: .error, "❌ " + text,

        className: T.self,
        callback: callback,
        delegate: delegate,
        value: value,
        file: file,
        line: line,
        function: function
    )
}
