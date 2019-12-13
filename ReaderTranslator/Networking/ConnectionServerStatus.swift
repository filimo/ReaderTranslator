//
//  ConnectionStatus.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 13/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Network

enum ErrorServerConnection: Error {
    case listener(error: NWError)
    case connection(text: String)

    var status: String {
        switch self {
        case .listener(let error):
            return "\(error)"
        case .connection(let text):
            return text
        }
    }
}

enum ConnectionServerStatus {
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
        case .started(let name, let passcode):
            return "Pass code for \(name): \(passcode)"
        case .connected:
            return "The server is connected"
        case .failed(let error):
            return "The server: \(error.status)"
        }
    }
}
