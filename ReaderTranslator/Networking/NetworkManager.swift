//
//  NetworkManager.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Network

class NetworkManager {
    var results: [NWBrowser.Result] = []
}

extension NetworkManager: PeerBrowserDelegate {
    // When the discovered peers change, update the list.
    func refreshResults(results: Set<NWBrowser.Result>) {
        self.results = [NWBrowser.Result]()
        for result in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                //                    if name != self.name {
                print(name)
                self.results.append(result)
                //                    }
            }
        }
    }
}
