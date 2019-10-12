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
    associatedtype ViewType
    
    func updateView(_ view: ViewType, context: Context)
    func makeView(context: Context) -> ViewType
}

extension ViewRepresentable {
    #if os(macOS)
    func makeNSView(context: Context) -> ViewType  {
        makeView(context: context)
    }
    func updateNSView(_ view: ViewType, context: Context) {
        updateView(view, context: context)
    }
    #else
    func makeUIView(context: Context) -> ViewType  {
        makeView(context: context)
    }
    func updateUIView(_ view: ViewType, context: Context) {
        updateView(view, context: context)
    }
    #endif
}
