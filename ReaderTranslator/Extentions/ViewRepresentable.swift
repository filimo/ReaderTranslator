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

    @MainActor func updateView(_ view: ViewType, context: Context)
    @MainActor func makeView(context: Context) -> ViewType
}

extension ViewRepresentable {
    #if os(macOS)
        @MainActor func makeNSView(context: Context) -> ViewType {
            print("\(theClassName)_makeView")
            return makeView(context: context)
        }

        @MainActor func updateNSView(_ view: ViewType, context: Context) {
            print("\(theClassName)_updateView")
            updateView(view, context: context)
        }

    #else
        @MainActor func makeUIView(context: Context) -> ViewType {
            print("\(theClassName)_makeView")
            return makeView(context: context)
        }

        @MainActor func updateUIView(_ view: ViewType, context: Context) {
            print("\(theClassName)_updateView")
            updateView(view, context: context)
        }
    #endif
}
