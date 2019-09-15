//
//  StatusBarView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        let pdfMode = Binding<Bool>(
            get: { self.store.mode == .pdf },
            set: { self.store.mode = $0 ? .pdf : .web }
        )

        return HStack {
            Toggle(isOn: pdfMode) {
                Text("WEB")
            }.fixedSize()
            Text("PDF").padding(.trailing, 20)
            Button(action: {
                SpeechSynthesizer.speech(text: self.store.selectedText)
            }) {
                Image(systemName: "volume.3.fill")
            }
            TextField("   ", text: $store.currentPage)
                .fixedSize()
                .keyboardType(.numberPad)
                .background(Color.gray)
            Text(" / \(self.store.pageCount)")
        }
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
