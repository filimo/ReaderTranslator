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

    static var coorinator: Coordinator? { get set }

    func updateView(_ view: ViewType, context: Context)
    func makeView(context: Context) -> ViewType
    func makeCoordinator(coordinator: @autoclosure () -> Coordinator) -> Coordinator
}

extension ViewRepresentable {
    #if os(macOS)
        func makeNSView(context: Context) -> ViewType {
            print("\(theClassName)_makeView")
            return makeView(context: context)
        }

        func updateNSView(_ view: ViewType, context: Context) {
            print("\(theClassName)_updateView")
            updateView(view, context: context)
        }

    #else
        func makeUIView(context: Context) -> ViewType {
            print("\(theClassName)_makeView")
            return makeView(context: context)
        }

        func updateUIView(_ view: ViewType, context: Context) {
            print("\(theClassName)_updateView")
            updateView(view, context: context)
        }
    #endif
}

extension ViewRepresentable {
    func makeCoordinator(coordinator: @autoclosure () -> Coordinator) -> Coordinator {
        if let coordinator = Self.coorinator { return coordinator }

        let coorinator = coordinator()
        Self.coorinator = coorinator

        return coorinator
    }
}
