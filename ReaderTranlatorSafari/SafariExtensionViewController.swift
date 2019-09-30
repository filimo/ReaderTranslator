//
//  SafariExtensionViewController.swift
//  ReaderTranlatorSafari
//
//  Created by Viktor Kushnerov on 9/30/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
