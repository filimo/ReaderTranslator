//
//  HostsView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI

struct ConnectionView: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var browser = NetBrowser()
    @State var passcode = "1111"

    init() {
        sharedBrowser = PeerBrowser()
        sharedBrowser?.delegate = browser
        sharedBrowser?.startBrowsing()
    }

    var body: some View {
        VStack {
            ConnectionView_Servers(browser: browser, passcode: $passcode)
            TextField("Enter pass code", text: $passcode)
            ConnectionView_Bookmarks()
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
