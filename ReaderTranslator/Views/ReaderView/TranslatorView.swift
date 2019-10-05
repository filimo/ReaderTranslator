//
//  TranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct TranslatorView: View {
    @Binding var text: URLQueryItem
    
    var body: some View {
        VStack {
            /** Hack: it or `Divider()` required to display TranslatorView properly `Divider()` takes more space **/
            Text("").frame(height: 1)
            Translator(text: $text)
        }
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorView(text: .constant(.init(name: "text", value: "test")))
        .environmentObject(Store.shared)
    }
}
