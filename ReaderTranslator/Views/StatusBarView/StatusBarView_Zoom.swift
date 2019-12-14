//
//  StatusBarView_Zoom.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Zoom: View {
    @ObservedObject var store = Store.shared
    #if !os(macOS)
    let zoom = Binding<String>(
        get: { String(format: "%.02f", CGFloat(Store.shared.zoom)) },
        set: {
            if let value = NumberFormatter().number(from: $0) {
                Store.shared.zoom = CGFloat(truncating: value)
            }
        }
    )
    #endif

    var body: some View {

        return Group {
            #if !os(macOS)
            if store.viewMode == .web {
                Divider().fixedSize()
                TextField("zoom", text: zoom)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(
                    action: { self.store.zoom -= 0.25 },
                    label: {
                        Image(systemName: "minus.magnifyingglass")
                })
                Slider(value: $store.zoom, in: 1...3).frame(width: 100)
                Button(
                    action: { self.store.zoom += 0.25 },
                    label: {
                        Image(systemName: "plus.magnifyingglass")
                })
            }
            #endif
        }
    }
}

struct StatusBarView_Zoom_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Zoom()
    }
}
