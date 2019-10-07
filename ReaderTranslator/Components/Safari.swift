//
//  Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#endif


struct Safari {
    private init() {}
}

#if os(macOS)
extension Safari {
    @discardableResult
    static func openSafari(_ url: URL) -> Bool {
        NSWorkspace.shared.open(url)
    }

    //TODO: implement keyCommands and performCommand
}
#else
extension Safari {
    static func openSafari(_ url: URL) -> () {
       UIApplication.shared.openSafari(url)
    }

    override public var keyCommands: [UIKeyCommand]? {
        //Voice selected text with any key since performCommand isn't fired because PageWebView isn't the first responder.
        SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true)
        return [.init(input: "1", modifierFlags: .command, action: #selector(performCommand))]
    }

    @objc func performCommand(sender: UIKeyCommand) {
        print(sender)
    }
}
#endif
