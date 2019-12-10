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
        Button(action: { self.isShow = true }, label: { Text("Size") })
        .sheet(isPresented: $isShow) {
            VStack {
//                List {
//                    ForEach(AvailableView.resiableViews, id: \.self) { view in
//                        Text(view.text).frame(width: 50, height: 10)
//                    }
//                    .onMove { (_, _) in
//
//                    }
//                }.frame(width: 200, height: 200)

//                ForEach(AvailableView.resiableViews, id: \.self) { view in
//                    HStack {
//                        Text(view.text)
//                        Spacer()
//                        TextField("", text: view.width).frame(width: 50)
//                    }
//                    .frame(width: 200)
//                }

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
