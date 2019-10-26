//
//  StatusBarView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct StatusBarView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        HStack {
            StatusBarView_ViewMode().padding(5)
            StatusBarView_PdfPage()
            StatusBarView_Tabs(viewMode: $store.viewMode, currentTab: $store.currentTab)
            StatusBarView_Zoom()
            StatusBarView_Voice().padding([.top, .bottom], 5)
            StatusBarView_Safari()
            StatusBarView_Bookmarks()
            StatusBarView_ViewsEnabler()
            openPDFPanelView
//            gTranslatorNavbarView
            speakView
        }.padding(.trailing, 20)
    }

    private var speakView: some View {
        if case let .speak(text) = self.store.translateAction {
            self.store.translateAction.next()
            SpeechSynthesizer.speak(text: text)
        }

        return EmptyView()
    }

    private var openPDFPanelView: some View {
        Group {
            if store.viewMode == .pdf {
                Spacer()
                Button(
                    action: {
                        OpenPanel.showChooseFileDialog(title: "Open PDF file", allowedFileTypes: ["pdf"]) { urlString in
                            guard let url = urlString else { return }

                            self.store.lastPdfPage = "1"
                            self.store.lastPdf = url
                        }
                    },
                    label: { Text("Open file") })
            } else {
                EmptyView()
            }
        }
    }

    private var gTranslatorNavbarView: some View {
        Group {
            Spacer()
            Button(action: {
                self.store.translateAction.add(.translator(text: ""))
                GTranslator.pageView?.goBack()
            }, label: { Text("􀉍") })
            Button(action: {
                GTranslator.pageView?.goForward()
            }, label: { Text("􀉑") })
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
