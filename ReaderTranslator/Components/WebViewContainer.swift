//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct WebViewContainer<Content>: View where Content: View {
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                self.content().frame(height: geometry.size.height).padding()
            }
        }
    }
}
