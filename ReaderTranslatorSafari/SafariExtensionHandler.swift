//
//  SafariExtensionHandler.swift
//  ReaderTranslatorSafari
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SafariServices
import Combine

class SafariExtensionHandler: SFSafariExtensionHandler {
    static private var message: PassthroughSubject<String, Never> = {
        let pub = PassthroughSubject<String, Never>()
        
        _  = pub
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { message in
                SharedContainer.set(value: message)
            }
        
        return pub
    }()
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
            SafariExtensionHandler.message.send(messageName)
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
