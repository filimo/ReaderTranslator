//
//  StatusBarView_Listener.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Network

struct StatusBarView_Listener: View {
    class Coordinator {}

    @State var passcode = ""
    private var generatePasscode: String { String("\(randomInt)\(randomInt)\(randomInt)\(randomInt)") }
    private let coordinator = Coordinator()
    private var randomInt: Int { Int.random(in: 0...9) }
    private let name = "ReaderTranslator"
    @State var connectionCount = 0

    var body: some View {
        Text("passcode: \(passcode)").onTapGesture {
            self.passcode = self.generatePasscode
            self.connectionCount += 1
            sharedListener?.stopListening()
            sharedListener = PeerListener(
                name: "\(self.name)_\(self.connectionCount)",
                passcode: self.passcode,
                delegate: self.coordinator)
        }
    }
}

extension StatusBarView_Listener.Coordinator: PeerConnectionDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
        //navigationController?.performSegue(withIdentifier: "showGameSegue", sender: nil)
        print("\(#function)")
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() {
        print("\(#function)")
    }
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        print(2)
    }
}

struct StatusBarView_Listener_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Listener()
    }
}
