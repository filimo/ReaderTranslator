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
        Logger.debug("P2P", "\(Self.self)", "\(#function)")
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
        Logger.debug("P2P", "\(Self.self)", "PeerBrowserDelegate", "\(#function)")
        status = .none
        servers = results.map { $0 }
    }
}

extension NetBrowser: PeerConnectionDelegate {
    func connectionReady() {
        Logger.debug("P2P", "\(Self.self)", "PeerBrowserDelegate", "\(#function)")
        status = .connected
    }

    func connectionFailed() {
        Logger.debug("P2P", "\(Self.self)", "PeerBrowserDelegate", "\(#function)")
        status = .failed(error: "failed")
    }

    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        Logger.debug("P2P", "\(Self.self)", "PeerBrowserDelegate", "\(#function)")
//        switch message.readerTranslatorMessageType {
//        case .invalid: print("Received invalid message")
//        case .send: store.bookmarks.merge(data: content)
//        }
    }
}
