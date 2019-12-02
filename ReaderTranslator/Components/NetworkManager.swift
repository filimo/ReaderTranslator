//
//  NetworkManager.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Network

class NetworkManager {
    var results: [NWBrowser.Result] = []
}

extension NetworkManager: PeerConnectionDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
//        navigationController?.performSegue(withIdentifier: "showGameSegue", sender: nil)
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() { }
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) { }
}
