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
        HStack {
            StatusBarView_Tabs(viewMode: $store.viewMode, currentTab: $store.currentTab)
            StatusBarView_Zoom()
            StatusBarView_PdfMode()
            StatusBarView_Voice()
            StatusBarView_PdfPage()
        }
    }
}

struct StatusBarView_Tabs: View {
    @Binding var viewMode: ViewMode
    @Binding var currentTab: Int
    
    var body: some View {
        Group {
            if viewMode == .web {
                Button(action: { self.currentTab = 0 }) {
                    Image(systemName: "1.circle\(iconStatus(0))")
                }
                Button(action: { self.currentTab = 1 }) {
                    Image(systemName: "2.circle\(iconStatus(1))")
                }
                Button(action: { self.currentTab = 2 }) {
                    Image(systemName: "3.circle\(iconStatus(2))")
                }
            }
        }
    }
    
    private func iconStatus(_ tab: Int) -> String {
        self.currentTab == tab ? ".fill" : ""
    }
}

struct StatusBarView_Zoom: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        let zoom = Binding<String>(
            get: { String(format: "%.02f", CGFloat(self.store.zoom)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.store.zoom = CGFloat(truncating: value)
                }
        }
        )
        
        return Group {
            if store.viewMode == .web {
                TextField("zoom", text: zoom)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: { self.store.zoom -= 0.25 }) {
                    Image(systemName: "minus.magnifyingglass")
                }
                Slider(value: $store.zoom, in: 1...3).frame(width: 100)
                Button(action: { self.store.zoom += 0.25 }) {
                    Image(systemName: "plus.magnifyingglass")
                }
            }
        }
    }
}
struct StatusBarView_PdfMode: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        let pdfMode = Binding<Bool>(
            get: { self.store.viewMode == .pdf },
            set: { self.store.viewMode = $0 ? .pdf : .web }
        )
        
        return Group {
            Toggle(isOn: pdfMode) {
                Text("WEB")
            }.fixedSize()
            Text("PDF").padding(.trailing, 20)
        }
    }
}

struct StatusBarView_PdfPage: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        return Group {
            if store.viewMode == .pdf {
                Text("  Page:")
                TextField("   ", text: self.$store.currentPage)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Text(" / \(self.store.pageCount)")
            }
        }
    }
}


struct StatusBarView_Voice: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            StatusBarView_Voice_Select()
            StatusBarView_Voice_Favorite()
            StatusBarView_Voice_Volume()
        }
    }
}

struct StatusBarView_Voice_Select: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
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
                            SpeechSynthesizer.speech()
                        }) {
                            Text("\(voice.name) \(voice.premium ? "(premium)" : "")")
                        }
                    }
            }
        }
    }
}

struct StatusBarView_Voice_Favorite: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            button()
            .contextMenu {
                ForEach(store.favoriteVoiceNames, id:\.id) { item in
                    Button(action: {
                        self.store.voiceLanguage = item.language
                        self.store.voiceName = item.voice
                        SpeechSynthesizer.speech()
                    }) {
                        Text("\(item.language) \(item.voice)")
                    }
                }
            }
        }
    }
    
    private func button() -> some View {
        if FavoriteVoiceName.isFavorite {
            return Button(action: {
                FavoriteVoiceName.removeCurrentVoice()
            }) {
                Image(systemName: "star.fill")
            }
        }else{
            return Button(action: {
                FavoriteVoiceName.addCurrentVoice()
            }) {
                Image(systemName: "star")
            }
        }
    }
}


struct StatusBarView_Voice_Volume: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            Toggle(isOn: $store.isVoiceEnabled) {
                Text("On:")
                Button(action: {
                    SpeechSynthesizer.speech()
                }) {
                    store.isVoiceEnabled ? Image(systemName: "volume.3.fill") : Image(systemName: "speaker")
                }
            }.fixedSize()
            Text("Rate:")
            TextField("   ", text: self.$store.voiceRate)
                .fixedSize()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
