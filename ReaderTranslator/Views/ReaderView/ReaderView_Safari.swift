//
//  ReaderView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Safari: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        var timer: Timer?
        
        return Group {
            #if os(macOS)
            if store.viewMode == .safari {
//                EditorNSTextView(text: $text)
                Text(store.selectedText)
                    .onAppear {
                        print("ReaderView_Safari_onAppear called")
                        timer?.invalidate()
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            print("ReaderView_Safari_onAppear", self.store.selectedText)
                            if self.store.selectedText == SharedContainer.string() { return }
                            self.store.selectedText = SharedContainer.string()
                            SpeechSynthesizer.speech()
                        }
                    }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
            }
            #endif
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
