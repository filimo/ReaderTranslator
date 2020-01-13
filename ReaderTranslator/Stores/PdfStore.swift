//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class PdfStore: ObservableObject {
    private init() {}
    static var shared = PdfStore()

    @Published var currentPdfPage = "1"
    @Published var pdfPageCount = 0
    @Published(wrappedValue: nil, key: "pdfAudio") var pdfAudio: URL?
    @Published(key: "lastPdf") var lastPdf: String = ""
    @Published(key: "lastPdfPage") var lastPdfPage = "1"
    @Published(key: "pdfZoom") var pdfZoom: CGFloat = 1 {
        didSet {
            PDFKitViewRepresentable.pdfView.scaleFactor = pdfZoom
        }
    }
}
