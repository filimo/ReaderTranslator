//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

#if os(macOS)
typealias ViewRepresentableType = NSViewRepresentable
#else
typealias ViewRepresentableType = UIViewRepresentable
#endif


protocol ViewRepresentable: ViewRepresentableType {
    func updateView(_ view: PageWebView, context: Context)
    func makeView(context: Context) -> PageWebView    
}

extension ViewRepresentable {
    #if os(macOS)
    func makeNSView(context: Context) -> PageWebView  {
        makeView(context: context)
    }
    func updateNSView(_ view: PageWebView, context: Context) {
        updateView(view, context: context)
    }
    #else
    func makeUIView(context: Context) -> PageWebView  {
        makeView(context: context)
    }
    func updateUIView(_ view: PageWebView, context: Context) {
        updateView(view, context: context)
    }
    #endif
}
