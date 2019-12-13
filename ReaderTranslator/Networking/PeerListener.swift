//
//  PeerListener.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Network

var sharedListener: PeerListener?

class PeerListener {

    weak var delegate: PeerConnectionDelegate?
    var listener: NWListener?
    var name: String
    let passcode: String

    // Create a listener with a name to advertise, a passcode for authentication,
    // and a delegate to handle inbound connections.
    init(name: String, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.name = name
        self.passcode = passcode
    }

    // Start listening and advertising.
    func startListening(stateUpdateHandler: ((NWListener.State) -> Void)?) {
        do {
            // Create the listener object.
            let listener = try NWListener(using: NWParameters(passcode: passcode))
            self.listener = listener

            // Set the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_reader_translator._tcp")

            listener.newConnectionHandler = { newConnection in
                if let delegate = self.delegate {
                    if sharedConnection == nil {
                        // Accept a new connection.
                        sharedConnection = PeerConnection(connection: newConnection, delegate: delegate)
                    } else {
                        // If a game is already in progress, reject it.
                        newConnection.cancel()
                    }
                }
            }

            // Start listening, and request updates on the main queue.
            listener.start(queue: .main)
        } catch {
            print("Failed to create listener")
            abort()
        }
    }

    func stopListening() {
        self.listener?.cancel()
        sharedConnection = nil
    }

    // If the user changes their name, update the advertised name.
    func resetName(_ name: String) {
        self.name = name
        if let listener = listener {
            // Reset the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_reader_translator._tcp")
        }
    }
}
