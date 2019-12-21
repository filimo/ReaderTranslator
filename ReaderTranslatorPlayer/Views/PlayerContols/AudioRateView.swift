//
//  AudioRateView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct AudioRateView: View {
    @ObservedObject var store = Store.shared

    @State var audioRate: Float = Store.shared.audio.rate {
        didSet {
            FileListView.player?.rate = audioRate
            store.audio.rate = audioRate
        }
    }

    var body: some View {
        HStack {
            Button(action: { self.audioRate = 0.2 }, label: { textView(".2") })
                .buttonStyle(RoundButtonStyle())
            Button(action: { self.audioRate = 0.5 }, label: { textView(".5") })
                .buttonStyle(RoundButtonStyle())
            Button(action: { self.audioRate -= 0.1 }, label: { textView("-") })
                .buttonStyle(RoundButtonStyle())
            Text(String(format: "%.1f", arguments: [audioRate])).padding(5)
            Button(action: { self.audioRate += 0.1 }, label: { textView("+") })
                .buttonStyle(RoundButtonStyle())
            Button(action: { self.audioRate = 1 }, label: { textView("1") })
                .buttonStyle(RoundButtonStyle())
        }
    }

    private func textView(_ text: String) -> some View {
        Text(text).frame(width: 30)
    }
}

struct AudioRateView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRateView()
    }
}
