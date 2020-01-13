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
                TextField(
                    "",
                    value: self.$store.rate,
                    formatter: NumberFormatter.localFloat,
                    onCommit: { SpeechSynthesizer.speak() })
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            #else
                TextField(
                    "",
                    value: self.$store.rate,
                    formatter: NumberFormatter.localFloat)
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
