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
    @EnvironmentObject var store: Store
    
    var body: some View {
        let pdfMode = Binding<Bool>(
            get: { self.store.viewMode == .pdf },
            set: { self.store.viewMode = $0 ? .pdf : .web }
        )

        return HStack {
            if store.viewMode == .web {
                Image(systemName: "minus.magnifyingglass").onTapGesture { self.store.zoom -= 0.5 }
                Slider(value: $store.zoom, in: 1...3).frame(width: 100)
                Image(systemName: "plus.magnifyingglass").onTapGesture { self.store.zoom += 0.5 }
            }
            
            Toggle(isOn: pdfMode) {
                Text("WEB")
            }.fixedSize()
            Text("PDF").padding(.trailing, 20)

            Text(store.voiceLanguage)
            .contextMenu {
                ForEach(SpeechSynthesizer.languages, id: \.self) { language in
                    Button(action: {
                        self.store.voiceLanguage = language
                        self.store.voiceName = "Select voice"
                    }) {
                        Text(language)
                    }
                }
            }
            Text(store.voiceName)
            .contextMenu {
                ForEach(SpeechSynthesizer.getVoices(language: store.voiceLanguage), id: \.id) { voice in
                    Button(action: {
                        self.store.voiceName = voice.name
                    }) {
                        Text("\(voice.name) \(voice.premium ? "(premium)" : "")")
                    }
                }
            }
            Toggle(isOn: $store.isVoiceEnabled) {
                Button(action: {
                    SpeechSynthesizer.speech(text: self.store.selectedText, voiceName: self.store.voiceName)
                }) {
                    store.isVoiceEnabled ? Image(systemName: "volume.3.fill") : Image(systemName: "speaker")
                }
            }.fixedSize()
            
            if store.viewMode == .pdf {
                Text("  Page:")
                TextField("   ", text: $store.currentPage)
                    .fixedSize()
                    .keyboardType(.numberPad)
                    .background(Color.gray)
                Text(" / \(self.store.pageCount)")
            }
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
