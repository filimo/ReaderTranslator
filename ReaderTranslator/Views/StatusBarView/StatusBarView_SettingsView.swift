//
//  SettingsView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_SettingsView: View {
//    @ObservedObject var viewStore = ViewsStore.shared //TextField uses ViewsStore via enum AvailableView

    var body: some View {
        Button(action: { ViewsStore.shared.showSettings = true }, label: { Text("Settings") })
    }
}

struct StatusBarView_SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

