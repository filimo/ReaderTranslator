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
    class Coordinator: ObservableObject {
        var name: String { "ReaderTranslator_\(connectionCount)" }
        var generatePasscode: String { String("\(randomInt)\(randomInt)\(randomInt)\(randomInt)") }
        private var randomInt: Int { Int.random(in: 0...9) }

        @Published var connectionCount = 0
        @Published var status = ConnectionStatus.none
        @Published var passcode = ""
    }

    @ObservedObject var coordinator: Coordinator = Coordinator()

    var body: some View {
        Text(coordinator.status.status).onTapGesture(perform: coordinator.start)
    }
}

extension StatusBarView_Listener.Coordinator {
    func stateUpdateHandler(newState: NWListener.State) {
        switch newState {
        case .ready:
            status = .ready
        case .failed(let error):
            status = .failed(error: .listener(error: error))
            // If the listener fails, re-start.
            print("Listener failed with \(error), restarting")
            sharedListener?.listener?.cancel()
            sharedListener?.startListening(stateUpdateHandler: stateUpdateHandler)

        default:
            break
        }
    }

    func start() {
        self.passcode = self.generatePasscode
        self.connectionCount += 1
        sharedListener?.stopListening()

        status = .started(name: name, passcode: passcode)
        sharedListener = PeerListener(name: name, passcode: self.passcode, delegate: self)
        sharedListener?.startListening(stateUpdateHandler: stateUpdateHandler)
    }
}

extension StatusBarView_Listener.Coordinator: PeerConnectionDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
        //navigationController?.performSegue(withIdentifier: "showGameSegue", sender: nil)
        status = .connected
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() {
        status = .failed(error: .connection(text: "connection failed"))
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
