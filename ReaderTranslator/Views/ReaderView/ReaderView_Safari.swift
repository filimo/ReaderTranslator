//
//  ReaderView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import os.log

struct ReaderView_Safari: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        Group {
            if store.viewMode == .safari {
        /** Hack: it or `Divider()` required to display TranslatorView properly `Divider()` takes more space **/
                Text("").frame(height: 1)
//                Text(store.selectedText) // temporarily disable
            }
        }
        .onAppear {
            SafariExtensionManager()
                .start(onMessageChanged: self.onMessageChanged(notificationName:))
        }
    }
    
    private func onMessageChanged(notificationName: String) {
        if let event = SharedContainer.getEvent()  {
            switch event.name {
            case "keydown":
                if let extra = event.extra,
                    extra.shiftKey == false,
                    extra.metaKey == false {
                    
                    if extra.keyCode == 65 { // a
                        self.store.isVoiceEnabled.toggle()
                    }
                    if extra.keyCode == 83 { // s
                        self.store.canSafariSendSelectedText.toggle()
                        if self.store.canSafariSendSelectedText {
                            self.store.selectedText = event.extra?.selectedText ?? ""
                        }
                    }
                }
            case "selectionchange":
                if store.canSafariSendSelectedText { store.selectedText = event.extra?.selectedText ?? "" }
            default:
                os_log("DOMEvent %@ is not recognized", type: .debug, event.name)
            }
        }else{
            os_log("🐞🐞🐞DOMEvent is nil", type: .error)
        }
    }
}

struct ReaderView_Safari_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Safari()
            .frame(maxWidth: 100)
            .environmentObject(Store.shared)
    }
}
