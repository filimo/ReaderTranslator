//
//  SafariExtensionHandler.swift
//  ReaderTranslatorSafari
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SafariServices
import Combine
import os.log

class SafariExtensionHandler: SFSafariExtensionHandler {
    typealias EventType = PassthroughSubject<String, Never>
    static private var anyCancellable: Set<AnyCancellable> = []
    static private var event: EventType = {
        let pub = EventType()
        
        pub
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { event in
                SharedContainer.setEvent(string: event)
                SafariExtensionManager.didMessageChanged()
            }
        .store(in: &SafariExtensionHandler.anyCancellable)
        
        return pub
    }()
    
    deinit {
        Self.anyCancellable.allCancel()
    }
    
    override func messageReceived(withName event: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            os_log("The extension received a message %@ from a script injected into %@ with userInfo %@",
                   type: .debug, event,
                   String(describing: properties?.url),
                   userInfo ?? [:])
            SafariExtensionHandler.event.send(event)
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
