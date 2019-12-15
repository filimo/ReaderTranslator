//
//  PeerConnection.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Network

var sharedConnection: PeerConnection?

protocol PeerConnectionDelegate: AnyObject {
    func connectionReady()
    func connectionFailed()
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
}

class PeerConnection {
    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let initiatedConnection: Bool

    // Create an outbound connection when the user initiates a game.
    init(endpoint: NWEndpoint, interface _: NWInterface?, passcode: String) {
//        self.delegate = delegate
        initiatedConnection = true

        let connection = NWConnection(to: endpoint, using: NWParameters(passcode: passcode))
        self.connection = connection

//        startConnection()
    }

    // Handle an inbound connection when the user receives a game request.
    init(connection: NWConnection, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        initiatedConnection = false

        startConnection()
    }

    // Handle the user exiting the game.
    func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }

    // Handle starting the peer-to-peer connection for both inbound and outbound connections.
    func startConnection() {
        guard let connection = connection else {
            return
        }

        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("\(connection) established")

                // When the connection is ready, start receiving messages.
                self.receiveNextMessage()

                // Notify your delegate that the connection is ready.
                if let delegate = self.delegate {
                    delegate.connectionReady()
                }
            case let .failed(error):
                print("\(connection) failed with \(error)")

                // Cancel the connection upon a failure.
                connection.cancel()

                // Notify your delegate that the connection failed.
                if let delegate = self.delegate {
                    delegate.connectionFailed()
                }
            default:
                break
            }
        }

        // Start the connection establishment.
        connection.start(queue: .main)
    }

    // Handle sending a "select character" message.
    func selectCharacter(_ character: String) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(readerTranslatorMessageType: .selectedCharacter)
        let context = NWConnection.ContentContext(identifier: "SelectCharacter",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(
            content: character.data(using: .unicode),
            contentContext: context,
            isComplete: true,
            completion: .idempotent
        )
    }

    // Handle sending a "move" message.
    func sendMove(_ move: String) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(readerTranslatorMessageType: .move)
        let context = NWConnection.ContentContext(identifier: "Move",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(
            content: move.data(using: .unicode),
            contentContext: context,
            isComplete: true,
            completion: .idempotent
        )
    }

    // Receive a message, deliver it to your delegate, and continue receiving more messages.
    func receiveNextMessage() {
        guard let connection = connection else {
            return
        }

        connection.receiveMessage { content, context, _, error in
            // Extract your message type from the received context.
            let message = context?.protocolMetadata(definition: ReaderTranslatorProtocol.definition)
            if let message = message as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(content: content, message: message)
            }
            if error == nil {
                // Continue to receive more messages until you receive and error.
                self.receiveNextMessage()
            }
        }
    }
}
