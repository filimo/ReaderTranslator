//
//  ContentView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var url = ""
    @EnvironmentObject var store: Store
        
    var body: some View {
        VStack {
            ReaderView(url: $url)
            StatusBarView()
        }
        .onAppear {
            self.onSelectedTextChanged()
        }
    }
    
    func onSelectedTextChanged() {
        _ = store.$selectedText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if(text != "") {
                    SpeechSynthesizer.speech(text: text, voiceName: self.store.voiceName)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
