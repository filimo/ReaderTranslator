//
//  ContentView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    init() {
        #if os(macOS)
        NSApplication.shared.servicesProvider = ServiceProvider()
        NSUpdateDynamicServices()
        #endif
    }

    var body: some View {
        VStack(alignment: .leading) {
            ReaderView()
            StatusBarView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
