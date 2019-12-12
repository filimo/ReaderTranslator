//
//  ContentView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI
import Network

struct ContentView: View {
    class Coordinator {}

    private var passcode = ""
    private var generatePasscode: String { String("\(randomInt)\(randomInt)\(randomInt)\(randomInt)") }
    private let coordinator = Coordinator()
    private var randomInt: Int { Int.random(in: 0...9) }

    init() {
        let name = "ReaderTranslator"
        passcode = generatePasscode

        #if os(macOS)
        NSApplication.shared.servicesProvider = ServiceProvider()
        NSUpdateDynamicServices()
        #endif

        if let listener = sharedListener {
            // If your app is already listening, just update the name.
            listener.resetName(name)
        } else {
            // If your app is not yet listening, start a new listener.
            sharedListener = PeerListener(name: name, passcode: passcode, delegate: coordinator)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ReaderView()
            StatusBarView(passcode: passcode)
        }
    }
}

extension ContentView.Coordinator: PeerConnectionDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
        //navigationController?.performSegue(withIdentifier: "showGameSegue", sender: nil)
        print(1)
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() { }
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        print(2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
