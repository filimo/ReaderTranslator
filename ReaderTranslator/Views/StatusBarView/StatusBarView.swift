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
        HStack() {
            StatusBarView_ViewMode().padding(5)
            StatusBarView_PdfPage()
            StatusBarView_Tabs(viewMode: $store.viewMode, currentTab: $store.currentTab)
            StatusBarView_Zoom()
            StatusBarView_Voice().padding([.top,.bottom], 5)
            StatusBarView_Safari()
            Spacer()
            Button(action: {
                self.store.translateAction = .translator(text: "")
                GTranslator.pageView?.goBack()
            }) { Text("􀉍") }
            Button(action: {
                GTranslator.pageView?.goForward()
            }) { Text("􀉑") }
        }.padding(.trailing, 20)
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView().environmentObject(Store.shared)
    }
}
