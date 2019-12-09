//
//  StatusBarView_Tabs.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Tabs: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        HStack {
            Button(
                action: { self.store.currentTab = 0 },
                label: { Image.sfSymbol("1.circle\(iconStatus(0))") })
            Button(
                action: { self.store.currentTab = 1 },
                label: { Image.sfSymbol("2.circle\(iconStatus(1))") })
            Button(
                action: { self.store.currentTab = 2 },
                label: { Image.sfSymbol("3.circle\(iconStatus(2))") })
        }
    }

    private func iconStatus(_ tab: Int) -> String {
        self.store.currentTab == tab ? ".fill" : ""
    }
}

struct StatusBarView_Tabs_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Tabs()
    }
}
