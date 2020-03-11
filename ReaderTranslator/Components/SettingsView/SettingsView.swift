//
//  SettingsView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 18/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewStore = ViewsStore.shared

    var body: some View {
        Group {
            if viewStore.showSettings {
                VStack {
                    SettingsView_Views()
                    SettingsView_Voice().padding([.top, .bottom], 5)

                    Button(
                        action: { self.viewStore.showSettings = false },
                        label: { Text("Close") }
                    )
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                .modifier(RoundedEdge(width: 2, color: .black, cornerRadius: 10))
                .shadow(radius: 10)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
