//
//  SpeechHandlerView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 19.04.2020.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SpeechHandlerView: View {
    @ObservedObject var store = Store.shared
    
    var body: some View {
        if case let .speak(text) = self.store.translateAction {
            store.translateAction.next()
            SpeechSynthesizer.speak(text: text)
        }

        return Text("")
    }
}

struct SpeechHandlerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechHandlerView()
    }
}
