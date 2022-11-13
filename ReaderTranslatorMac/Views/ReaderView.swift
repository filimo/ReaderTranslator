//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReaderView: View {
    @ObservedObject var viewsStore = ViewsStore.shared

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                #if os(macOS)
                    SafariView()
                #endif
                ForEach(AvailableView.resiableViews, id: \.self) { view in
                    if view.isEnabled { view.view }
                }
            }.padding(.bottom, 20)
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView()
    }
}
