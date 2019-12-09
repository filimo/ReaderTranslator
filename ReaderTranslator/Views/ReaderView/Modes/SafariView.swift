//
//  ReaderView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import os.log

struct SafariView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        Group {
            Text("").frame(width: 1)
        }
        .onAppear {
            SafariExtensionManager()
                .start(onMessageChanged: self.onMessageChanged(notificationName:))
        }
    }

    private func onMessageChanged(notificationName: String) {
        guard let event = SharedContainer.getEvent() else {
            os_log("🐞🐞🐞DOMEvent is nil", type: .error)
            return
        }

        switch event.name {
        case "keydown": onMessageChanged_keydown(event: event)
        case "selectionchange": onMessageChanged_selectionchange(event: event)
        case "selectionchangeWithoutSpeaking": onMessageChanged_selectionchange(event: event, isSpeaking: false)
        case "addNewPhraseBefore": onMessageChanged_addNewPhraseBefore(event: event)
        case "addNewPhraseAfter": onMessageChanged_addNewPhraseAfter(event: event)
        default: os_log("DOMEvent name: %@ is not recognized", type: .debug, event.name)
        }
        switch event.source {
        case "video": onMessageChanged_player(event: event)
        default: os_log("DOMEvent source: %@ is not recognized", type: .debug, event.name)
        }
    }

    private func onMessageChanged_keydown(event: DOMEvent) {
        if let extra = event.extra,
            extra.shiftKey != true,
            extra.metaKey != true {

            if extra.altKey == true && extra.keyCode == 65 { // Alt+a
                store.isVoiceEnabled.toggle()
                return
            }
            if extra.altKey == true && extra.keyCode == 83 { // Alt+s
                store.canSafariSendSelectedText.toggle()
                if store.canSafariSendSelectedText {
                    store.translateAction.add(.gTranslator(text: event.extra?.selectedText ?? ""))
                }
                return
            }
            if extra.altKey == true {
                SpeechSynthesizer.speak()
                return
            }
        }
    }

    private func onMessageChanged_player(event: DOMEvent) {
        guard let extra = event.extra else { return }

        switch event.name {
        case "playbackRate": if let playbackRate = extra.playbackRate { store.playbackRate = playbackRate }
//        case "pause": SpeechSynthesizer.speak()
        case "play": SpeechSynthesizer.stop()
        default: os_log("DOMEvent player: %@ is not recognized", type: .debug, event.name)
        }
    }

    private func onMessageChanged_selectionchange(event: DOMEvent, isSpeaking: Bool = true) {
        if store.canSafariSendSelectedText {
            if let extra = event.extra,
                extra.altKey != true && extra.metaKey != true {

                let text = event.extra?.selectedText ?? ""
                store.translateAction.addAll(text: text, isSpeaking: isSpeaking)
            }
        }
    }

    private func onMessageChanged_addNewPhraseBefore(event: DOMEvent) {
        if store.canSafariSendSelectedText {
            guard let text = event.extra?.selectedText else { return }
            store.translateAction.addAll(text: "\(text) \(store.translateAction.getText())")
        }
    }

    private func onMessageChanged_addNewPhraseAfter(event: DOMEvent) {
        if store.canSafariSendSelectedText {
            guard let text = event.extra?.selectedText else { return }
            store.translateAction.addAll(text: "\(store.translateAction.getText()) \(text)")
        }
    }
}

struct ReaderView_Safari_Previews: PreviewProvider {
    static var previews: some View {
        SafariView().frame(maxWidth: 100)
    }
}
