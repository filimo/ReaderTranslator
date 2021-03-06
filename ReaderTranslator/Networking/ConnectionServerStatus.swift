//
//  ConnectionStatus.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 13/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Foundation
import Network

enum ErrorServerConnection: Error {
    case listener(error: NWError)
    case connection(text: String)

    var status: String {
        switch self {
        case let .listener(error):
            return "\(error)"
        case let .connection(text):
            return text
        }
    }
}

enum ConnectionServerStatus: Equatable {
    static func == (lhs: ConnectionServerStatus, rhs: ConnectionServerStatus) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.ready, .ready): return true
        case (let .started(lName, lPasscode), let .started(rName, rPasscode)):
            return lName == rName && lPasscode == rPasscode
        case (.connected, .connected): return true
        case let (.failed(lError), .failed(rError)): return lError.status == rError.status
        default: return false
        }
    }

    case none
    case started(name: String, passcode: String)
    case ready
    case connected
    case failed(error: ErrorServerConnection)

    var status: String {
        switch self {
        case .none:
            return "Start the server"
        case .ready:
            return "The server is ready"
        case let .started(name, passcode):
            return "Pass code for \(name): \(passcode)"
        case .connected:
            return "The server is connected"
        case let .failed(error):
            return "The server: \(error.status)"
        }
    }
}



