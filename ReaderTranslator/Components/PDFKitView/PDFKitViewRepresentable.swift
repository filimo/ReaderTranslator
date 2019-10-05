//
//  PDFKitViewRepresentable.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit

#if os(macOS)
struct PDFKitViewRepresentable: NSViewRepresentable {
    @Binding var url: URL?
    static let pdfView = PDFView()

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitViewRepresentable
        
        init(_ parent: PDFKitViewRepresentable) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> PDFKitViewRepresentable.Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> PDFView {
        PDFKitViewRepresentable.pdfView
    }

    func updateNSView(_ uiView: PDFView, context: Context) {
        if PDFKitViewRepresentable.pdfView.document != nil { return }
        if let url = url {
//TODO:            PDFKitViewRepresentable.pdfView.autoresizingMask = [.flexibleWidth]
            PDFKitViewRepresentable.pdfView.autoScales = true
            PDFKitViewRepresentable.pdfView.document = PDFDocument(url: url)
            PDFKitViewRepresentable.pdfView.delegate = context.coordinator
        }
    }
    
    static func getSelectedText() -> String {
        guard let selections = PDFKitViewRepresentable.pdfView.currentSelection?.selectionsByLine() else { return "" }

        return selections
            .map { selection in selection.string! }
            .joined(separator: " ")
    }
}
#else
struct PDFKitViewRepresentable: UIViewRepresentable {
    @Binding var url: URL?
    static let pdfView = PDFView()

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitViewRepresentable
        
        init(_ parent: PDFKitViewRepresentable) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> PDFKitViewRepresentable.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PDFView {
        PDFKitViewRepresentable.pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if PDFKitViewRepresentable.pdfView.document != nil { return }
        if let url = url {
            PDFKitViewRepresentable.pdfView.autoresizingMask = [.flexibleWidth]
            PDFKitViewRepresentable.pdfView.autoScales = true
            PDFKitViewRepresentable.pdfView.document = PDFDocument(url: url)
            PDFKitViewRepresentable.pdfView.delegate = context.coordinator
        }
    }
    
    static func getSelectedText() -> String {
        guard let selections = PDFKitViewRepresentable.pdfView.currentSelection?.selectionsByLine() else { return "" }

        return selections
            .map { selection in selection.string! }
            .joined(separator: " ")
    }
}
#endif
