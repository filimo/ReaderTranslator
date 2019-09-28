//
//  StatusBarView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct StatusBarView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        HStack {
            StatusBarView_Tabs(viewMode: $store.viewMode, currentTab: $store.currentTab)
            StatusBarView_Zoom()
            StatusBarView_PdfMode()
            StatusBarView_Voice()
            StatusBarView_PdfPage()
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
