//
//  StatusBarView_Zoom.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Zoom: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        let zoom = Binding<String>(
            get: { String(format: "%.02f", CGFloat(self.store.zoom)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.store.zoom = CGFloat(truncating: value)
                }
        }
        )
        
        return Group {
            if store.viewMode == .web {
                Divider().fixedSize()
                TextField("zoom", text: zoom)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: { self.store.zoom -= 0.25 }) {
                    Image(systemName: "minus.magnifyingglass")
                }
                Slider(value: $store.zoom, in: 1...3).frame(width: 100)
                Button(action: { self.store.zoom += 0.25 }) {
                    Image(systemName: "plus.magnifyingglass")
                }
            }
        }
    }
}

struct StatusBarView_Zoom_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Zoom().environmentObject(Store.shared)
    }
}
