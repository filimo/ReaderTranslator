//
//  SettingsView_Views.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 11/3/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView_Views: View {
    var body: some View {
        ForEach(AvailableView.resiableViews, id: \.self) { view in
            HStack {
                TextField(
                    "",
                    value: view.order,
                    formatter: NumberFormatter.localInt
                ).frame(width: 20)
                Text(view.text).frame(width: 150, alignment: .leading)
                TextField(
                    "",
                    value: view.width,
                    formatter: NumberFormatter.localCGFloat
                ).frame(width: 50)
            }
        }
    }
}

struct SettingsView_Views_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView_Views()
    }
}
