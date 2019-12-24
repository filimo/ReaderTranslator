//
//  OSLog.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 24/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import os.log
import Foundation

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let p2p = OSLog(subsystem: subsystem, category: "P2P")
}
