//
//  GTranslatorView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 15/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct GTranslatorView: View {
    var sentence: LongmanSentence

    var body: some View {
        GTranslatorRepresenter(sentence: sentence.text)
            .navigationBarItems(trailing:
                Button(action: {
                    LongmanStore.share.addAudio(url: self.sentence.url)
                    LongmanStore.share.next()
                }, label: { self.soundIco })
            )
    }

    private var soundIco: some View {
        Image(systemName: "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 10)
    }
}

struct GTranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        GTranslatorView(sentence: .init(text: "Hello. I am test.", url: URL(string: "")!))
    }
}
