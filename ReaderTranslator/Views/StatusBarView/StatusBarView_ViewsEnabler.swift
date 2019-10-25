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

    var body: some View {
        HStack(spacing: 0) {
            Divider().fixedSize()
            button(.wikipedia)
            button(.macmillan)
            button(.collins)
            button(.longman)
            button(.reverso)
            button(.translator)
        }
    }

    private func button(_ view: AvailableView) -> some View {
        Group {
            Text(view.rawValue)
                .background(store.enabledViews.contains(view) ? Color.red : Color.clear)
                .onTapGesture {
                    self.toggle(view)
                }
            Text("􀈅")
                .padding(.trailing, 5)
                .onTapGesture(count: 1) {
                    self.store.translateAction = view.getAction()
                    self.store.enabledViews.insert(view)
                }
        }
    }

    private func toggle(_ view: AvailableView) {
        if store.enabledViews.contains(view) {
           store.enabledViews.remove(view)
        } else {
            self.store.translateAction = view.getAction()
            store.enabledViews.insert(view)
        }
    }
}

struct StatusBarView_ViewsEnabler_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_ViewsEnabler()
    }
}
