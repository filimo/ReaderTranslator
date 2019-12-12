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
        startListening()
    }

    // Start listening and advertising.
    func startListening() {
        do {
            // Create the listener object.
            let listener = try NWListener(using: NWParameters(passcode: passcode))
            self.listener = listener

            // Set the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_reader_translator._tcp")

            listener.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    print("Listener ready on \(String(describing: listener.port))")
                case .failed(let error):
                    // If the listener fails, re-start.
                    print("Listener failed with \(error), restarting")
                    listener.cancel()
                    self.startListening()
                default:
                    break
                }
            }

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

    // If the user changes their name, update the advertised name.
    func resetName(_ name: String) {
        self.name = name
        if let listener = listener {
            // Reset the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_reader_translator._tcp")
        }
    }
}
