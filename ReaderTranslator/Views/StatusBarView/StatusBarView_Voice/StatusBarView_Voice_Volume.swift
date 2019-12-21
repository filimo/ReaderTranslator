//
//  StatusBarView_Voice_Volume.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Volume: View {
    @ObservedObject var store = AudioStore.shared

    var body: some View {
        Group {
            Text("Rate:")
            #if os(macOS)
                TextField("   ", text: self.$store.rate, onCommit: { SpeechSynthesizer.speak() })
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            #else
                TextField("   ", text: self.$store.rate)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            #endif
        }
    }
}

struct StatusBarView_Voice_Volume_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice_Volume()
    }
}
