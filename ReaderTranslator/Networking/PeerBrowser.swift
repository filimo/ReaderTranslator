//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Network
import SwiftUI

var sharedBrowser: PeerBrowser?

// Update the UI when you receive new browser results.
protocol PeerBrowserDelegate: AnyObject {
    func refreshResults(results: Set<NWBrowser.Result>)
}

class PeerBrowser {
    weak var delegate: PeerBrowserDelegate?
    var browser: NWBrowser?

    // Create a browsing object with a delegate.
//    init(delegate: PeerBrowserDelegate) {
//        self.delegate = delegate
//        startBrowsing()
//    }

    // Start browsing for services.
    func startBrowsing() {
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true

        // Browse for a custom "_reader_translator._tcp" service type.
        let browser = NWBrowser(for: .bonjour(type: "_reader_translator._tcp", domain: nil), using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case let .failed(error):
                // Restart the browser if it fails.
                print("Browser failed with \(error), restarting")
                browser.cancel()
                self.startBrowsing()
            default:
                break
            }
        }

        // When the list of discovered endpoints changes, refresh the delegate.
        browser.browseResultsChangedHandler = { results, _ in
            self.delegate?.refreshResults(results: results)
        }

        // Start browsing and ask for updates on the main queue.
        browser.start(queue: .main)
    }
}
