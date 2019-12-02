//
//  RewindView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct RewindView: View {
    var body: some View {
        HStack {
            Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
                .buttonStyle(RoundButtonStyle())
            rewindButton(label: "-100", step: -100)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)
            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+100", step: 100)
        }
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: { player?.currentTime += step }, label: { Text(label) })
            .buttonStyle(RoundButtonStyle())
    }
}

struct RewindView_Previews: PreviewProvider {
    static var previews: some View {
        RewindView()
    }
}
