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
            if store.viewMode == .safari {
                Text("").frame(width: 1)
            }
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
        case "addNewPhrase": onMessageChanged_addNewPhrase(event: event)
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
                    store.translateAction.add(.translator(text: event.extra?.selectedText ?? ""))
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
        case "play": SpeechSynthesizer.speak()
        case "stop": SpeechSynthesizer.stop()
        default: os_log("DOMEvent player: %@ is not recognized", type: .debug, event.name)
        }
    }

    private func onMessageChanged_selectionchange(event: DOMEvent) {
        if store.canSafariSendSelectedText {
            if let extra = event.extra,
                extra.altKey != true && extra.metaKey != true {

                let text = event.extra?.selectedText ?? ""
                store.translateAction.addAll(text: text)
            }
        }
    }

    private func onMessageChanged_addNewPhrase(event: DOMEvent) {
        if store.canSafariSendSelectedText {
            guard let text = event.extra?.selectedText else { return }
            store.translateAction.addAll(text: "\(text) \(store.translateAction.getText())")
        }
    }
}

struct ReaderView_Safari_Previews: PreviewProvider {
    static var previews: some View {
        SafariView().frame(maxWidth: 100)
    }
}
