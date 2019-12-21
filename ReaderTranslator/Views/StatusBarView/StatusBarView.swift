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

            StatusBarView_Voice().padding([.top, .bottom], 5)
            StatusBarView_Safari()
            StatusBarView_Bookmarks()
            StatusBarView_ViewsEnabler()
//            gTranslatorNavbarView
            speechHandler
            playbackRateView
            SettingsView()
            StatusBarView_Sync()
        }.padding(.trailing, 20)
    }

    private var speechHandler: some View {
        if case let .speak(text) = self.store.translateAction {
            self.store.translateAction.next()
            SpeechSynthesizer.speak(text: text)
        }

        return EmptyView()
    }

    private var playbackRateView: some View {
        Group {
            if viewsStore.enabledViews.contains(.safari) {
                Text(String(format: "PlaybackRate: %.2f", [audioStore.playbackRate]))
            }
        }
    }

    private var gTranslatorNavbarView: some View {
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
