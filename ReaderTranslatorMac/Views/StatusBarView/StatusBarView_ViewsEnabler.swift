//
//  StatusBarView_ViewsEnabler.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 24/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_ViewsEnabler: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var viewsStore = ViewsStore.shared

    private let buttons: [AvailableView] = [
        .bookmarks,
        .wikipedia,
        .macmillan,
        .collins,
        .merriamWebster,
        .stackExchange,
        .longman,
        .cambridge,
        .reverso,
        .gTranslator,
        .deepL,
        .yTranslator,
        .pdf,
        .web,
        .safari
    ]

    var body: some View {
        HStack(spacing: 0) {
            Divider().fixedSize()
            ForEach(buttons, id: \.self) { self.buttonView($0) }
        }
    }

    private func buttonView(_ view: AvailableView) -> some View {
        Text(view.rawValue)
            .background(view.isEnabled ? Color.red : Color.clear)
            .padding(.trailing, 5)
            .onTapGesture {
                self.viewsStore.toggleView(view: view)
            }
    }
}

struct StatusBarView_ViewsEnabler_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_ViewsEnabler()
    }
}
