//
//  Browser.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Network
import SwiftUI

class NetBrowser: ObservableObject {
    @Published var servers = [NWBrowser.Result]()
    @Published var status = ConnectionClientStatus.none
    @ObservedObject var store = Store.shared

    func hostInfo(_ server: NWBrowser.Result) -> String {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = server.endpoint {
            return name
        } else {
            return "empty"
        }
    }

    func connectToServer(server: NWBrowser.Result, passcode: String) {
        Logger.log(log: .p2p)
        sharedConnection = PeerConnection(
            endpoint: server.endpoint,
            interface: server.interfaces.first,
            passcode: passcode
        )
        sharedConnection?.delegate = self
        sharedConnection?.startConnection()
    }
}

extension NetBrowser: PeerBrowserDelegate {
    func refreshResults(results: Set<NWBrowser.Result>) {
        Logger.log(log: .p2p, delegate: "PeerBrowserDelegate")
        status = .none
        servers = results.map { $0 }
    }
}

extension NetBrowser: PeerConnectionDelegate {
    func connectionReady() {
        Logger.log(log: .p2p, delegate: "PeerBrowserDelegate")
        status = .connected
    }

    func connectionFailed() {
        Logger.log(log: .p2p, delegate: "PeerBrowserDelegate")
        status = .failed(error: "failed")
    }

    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        Logger.log(log: .p2p, delegate: "PeerBrowserDelegate")
//        switch message.readerTranslatorMessageType {
//        case .invalid: print("Received invalid message")
//        case .send: store.bookmarks.merge(data: content)
//        }
    }
}
