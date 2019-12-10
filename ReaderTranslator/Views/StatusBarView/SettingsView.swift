//
//  SettingsView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var store = Store.shared

    @State var isShow = false

    var body: some View {
        Button(action: { self.isShow = true }, label: { Text("Settings") })
        .sheet(isPresented: $isShow) {
            VStack {
                ForEach(AvailableView.resiableViews, id: \.self) { view in
                    HStack {
                        TextField("", text: view.order).frame(width: 20)
                        Text(view.text)
                        Spacer()
                        TextField("", text: view.width).frame(width: 50)
                    }
                    .frame(width: 200)
                }

                Button(action: { self.isShow = false }, label: { Text("Close") }).padding()
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
