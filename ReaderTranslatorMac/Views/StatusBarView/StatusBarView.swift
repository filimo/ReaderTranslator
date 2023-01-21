//
//  StatusBarView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI

struct StatusBarView: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var viewsStore = ViewsStore.shared
    @ObservedObject var audioStore = AudioStore.shared

    var body: some View {
        HStack {
            StatusBarView_Zoom()

            StatusBarView_Safari()
            StatusBarView_Bookmarks()
            StatusBarView_ViewsEnabler()
            //            gTranslatorNavbarView
            SpeechHandlerView()

            if AvailableView.safari.isEnabled {
                Text(String(format: "Apple: %.2f", [audioStore.playbackRate]))
            }

            StatusBarView_SettingsView()
            //            StatusBarView_Sync()

            Button("Speak") {
                SpeechSynthesizer.speak(isVoiceEnabled: true)
            }
            
            Toggle("Clipboard", isOn: $store.enabledClipboard)
                .padding(2)
                .background(.white)
                .cornerRadius(5)
            
        }.padding(5)
    }
}

extension StatusBarView {
    var gTranslatorNavbarView: some View {
        Group {
            Spacer()
            Button(action: {
                self.store.translateAction.add(.gTranslator(text: ""))
                GTranslatorRepresenter.pageView?.goBack()
            }, label: { Image.sfSymbol("arrowshape.turn.up.left.fill") })
            Button(action: {
                GTranslatorRepresenter.pageView?.goForward()
            }, label: { Image.sfSymbol("arrowshape.turn.up.right.fill") })
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
