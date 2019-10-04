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
                Text(store.selectedText)
            }
        }
        .onAppear {
            SafariExtensionManager().start(onMessageChanged: self.onMessageChanged(notificationName:))
        }
    }
    
    private func onMessageChanged(notificationName: String) {
        if let event = SharedContainer.getEvent()  {
            switch event.name {
            case "keydown":
                if let extra = event.extra {
                    if extra.altKey == true && extra.metaKey == true { //Alt+Cmd
                        if extra.keyCode == 88 { // x
                            self.store.isVoiceEnabled.toggle()
                        }
                        if extra.keyCode == 90 { // z
                            self.store.canSafariSendSelectedText.toggle()
                            if self.store.canSafariSendSelectedText {
                                self.store.selectedText = event.extra?.selectedText ?? ""
                            }
                        }
                    }
                }
            case "selectionchange":
                if store.canSafariSendSelectedText { store.selectedText = event.extra?.selectedText ?? "" }
            default:
                os_log("🐞🐞🐞DOMEvent %@ is not recognized", type: .error, event.name)
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
