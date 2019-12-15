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
    private let buttons: [AvailableView] = [
        .bookmarks,
        .wikipedia,
        .macmillan,
        .collins,
        .longman,
        .reverso,
        .gTranslator,
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
        Group {
            Text(view.rawValue)
                .background(store.enabledViews.contains(view) ? Color.red : Color.clear)
                .onTapGesture {
                    self.toggle(view)
                }
            Image.sfSymbol("square.and.arrow.down.fill")
                .padding(.trailing, 5)
                .onTapGesture(count: 1) {
                    self.store.translateAction.add(view.getAction())
                    self.store.enabledViews.insert(view)
                }
        }
    }

    private func toggle(_ view: AvailableView) {
        if store.enabledViews.contains(view) {
            store.enabledViews.remove(view)
        } else {
            store.translateAction.add(view.getAction())
            store.enabledViews.insert(view)
        }
    }
}

struct StatusBarView_ViewsEnabler_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_ViewsEnabler()
    }
}
