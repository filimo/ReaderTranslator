//
//  Server.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Network
import os.log
import SwiftUI

class Server: ObservableObject {
    var name: String { "ReaderTranslator_\(connectionCount)" }
    var generatePasscode: String { String("\(randomInt)\(randomInt)\(randomInt)\(randomInt)") }
    private var randomInt: Int { Int.random(in: 0 ... 9) }

    @Published var connectionCount = 0
    @Published var status = ConnectionServerStatus.none
    @Published var passcode = ""
}

extension Server {
    func stateUpdateHandler(newState: NWListener.State) {
        Logger.log(log: .p2p, value: newState)
        switch newState {
        case .ready:
            status = .ready
        case let .failed(error):
            status = .failed(error: .listener(error: error))
            // If the listener fails, re-start.
            print("Listener failed with \(error), restarting")
            sharedListener?.listener?.cancel()
            sharedListener?.startListening()

        default:
            break
        }
    }

    func start() {
        Logger.log(log: .p2p)
        passcode = "1111" // self.generatePasscode
        connectionCount += 1
        sharedListener?.stopListening()

        status = .started(name: name, passcode: passcode)
        sharedListener = PeerListener(name: name, passcode: passcode, delegate: self)
        sharedListener?.startListening()
    }
}

extension Server: PeerConnectionDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
        Logger.log(log: .p2p, delegate: "PeerConnectionDelegate")
        // navigationController?.performSegue(withIdentifier: "showGameSegue", sender: nil)
        status = .connected
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() {
        Logger.log(log: .p2p, delegate: "PeerConnectionDelegate")
        status = .failed(error: .connection(text: "connection failed"))
        start()
    }

    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        Logger.log(log: .p2p, delegate: "PeerConnectionDelegate", value: message)
        guard let content = content else { return }
        if let text = String(data: content, encoding: .unicode) {
            print(text)
        }
    }
}
