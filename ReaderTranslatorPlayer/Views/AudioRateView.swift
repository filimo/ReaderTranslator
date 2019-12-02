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

    @State var audioRate: Float = Store.shared.audioRate {
        didSet {
            player?.rate = audioRate
            store.audioRate = audioRate
        }
    }

    var body: some View {
        HStack {
            Button(action: { self.audioRate -= 0.1 }, label: { Text("-") })
                .buttonStyle(RoundButtonStyle())
            Text(String(format: "%.1f", arguments: [audioRate])).padding(5)
            Button(action: { self.audioRate += 0.1 }, label: { Text("+") })
                .buttonStyle(RoundButtonStyle())
        }
    }
}

struct AudioRateView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRateView()
    }
}
