//
//  ConnectionView_Servers.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Network
import SwiftUI

struct ConnectionView_Servers: View {
    @ObservedObject var browser: NetBrowser
    @Binding var passcode: String

    var body: some View {
        List {
            ForEach(browser.servers, id: \.self) { server in
                self.connectionButton(server: server)
            }
        }
    }

    private func connectionButton(server: NWBrowser.Result) -> some View {
        Button(
            action: { self.browser.connectToServer(server: server, passcode: self.passcode) },
            label: {
                HStack {
                    Text(browser.hostInfo(server))
                    Spacer()
                    Text(browser.status.status)
                }
            }
        )
    }
}
