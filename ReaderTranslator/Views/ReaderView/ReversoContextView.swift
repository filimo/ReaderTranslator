//
//  TranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReversoContextView: View {
    @Binding var text: String
    
    var body: some View {
        VStack {
            /** Hack: it or `Divider()` required to display TranslatorView properly `Divider()` takes more space **/
            Text("").frame(height: 1)
            ReversoContext(text: $text)
        }
    }
}

struct ContextReversoView_Previews: PreviewProvider {
    static var previews: some View {
        ReversoContextView(text: .constant("human being"))
        .environmentObject(Store.shared)
    }
}
