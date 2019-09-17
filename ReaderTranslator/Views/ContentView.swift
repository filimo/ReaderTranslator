//
//  ContentView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
        
    var body: some View {
        VStack {
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
