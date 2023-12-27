//
//  SafariExtensionHandler.swift
//  ReaderTranslatorSafari
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import os.log
import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    typealias EventType = PassthroughSubject<String, Never>
    private var anyCancellable: Set<AnyCancellable> = []
    private lazy var eventType: EventType = {
        let pub = EventType()

        pub
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { event in
                SharedContainer.setEvent(string: event)
                SafariExtensionManager.didMessageChanged()
            }
            .store(in: &anyCancellable)

        return pub
    }()

    deinit {
        anyCancellable.cancelAndRemoveAll()
    }

    override func messageReceived(withName event: String, from page: SFSafariPage, userInfo: [String: Any]?) {
        // This method will be called when a content script provided
        // by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            os_log("The extension received a message %@ from a script injected into %@ with userInfo %@",
                   type: .debug, event,
                   String(describing: properties?.url),
                   userInfo ?? [:])
            self.eventType.send(event)
        }
    }

    override func validateToolbarItem(
        in _: SFSafariWindow,
        validationHandler: @escaping ((Bool, String) -> Void)
    ) {
        // This is called when Safari's state changed in some way
        // that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }

    override func popoverViewController() -> SFSafariExtensionViewController {
        SafariExtensionViewController.shared
    }
}

