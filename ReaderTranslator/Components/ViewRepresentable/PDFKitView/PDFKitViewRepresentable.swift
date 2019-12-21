//
//  PDFKitViewRepresentable.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import PDFKit
import SwiftUI

#if os(macOS)
    struct PDFKitViewRepresentable: NSViewRepresentable {
        @Binding var url: String
        static let pdfView = PDFView()

        class Coordinator: NSObject, PDFViewDelegate {
            var parent: PDFKitViewRepresentable

            init(_ parent: PDFKitViewRepresentable) {
                self.parent = parent
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeNSView(context _: Context) -> PDFView {
            Self.pdfView
        }

        func updateNSView(_: PDFView, context: Context) {
            if url == "" || Self.pdfView.document?.documentURL?.absoluteString == url { return }
            if let url = URL(string: url) {
                Self.pdfView.autoScales = true
                Self.pdfView.document = PDFDocument(url: url)
                Self.pdfView.delegate = context.coordinator
            }
        }

        static func getSelectedText() -> String {
            guard let selections = Self.pdfView.currentSelection?.selectionsByLine() else { return "" }

            return selections
                .map { selection in selection.string! }
                .joined(separator: " ")
        }
    }

#else
    struct PDFKitViewRepresentable: UIViewRepresentable {
        @Binding var url: URL?
        static let pdfView = PDFView()

        class Server: NSObject, PDFViewDelegate {
            var parent: PDFKitViewRepresentable

            init(_ parent: PDFKitViewRepresentable) {
                self.parent = parent
            }
        }

        func makeCoordinator() -> Server {
            Server(self)
        }

        func makeUIView(context _: Context) -> PDFView {
            Self.pdfView
        }

        func updateUIView(_: PDFView, context: Context) {
            if Self.pdfView.document != nil { return }
            if let url = url {
                Self.pdfView.autoresizingMask = [.flexibleWidth]
                Self.pdfView.autoScales = true
                Self.pdfView.document = PDFDocument(url: url)
                Self.pdfView.delegate = context.server
            }
        }

        static func getSelectedText() -> String {
            guard let selections = Self.pdfView.currentSelection?.selectionsByLine() else { return "" }

            return selections
                .map { selection in selection.string! }
                .joined(separator: " ")
        }
    }
#endif
