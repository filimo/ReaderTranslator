//
//  PDFKitRepresentedView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/8/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit
import Combine

var willCurrentPageChanged: AnyCancellable?
var willViewModeChanged: AnyCancellable?

struct PDFKitView: View {
    @State var url: URL?

    @EnvironmentObject var store: Store

    @UserDefault(key: "LAST_PAGE", defaultValue: "1")
    var lastPage: String
    
    var body: some View {
        PDFKitViewRepresentable(url: $url)
        .onAppear {
            self.start()
            
            // TODO: [Fix PDFView issue] Set the current page after PDFView is rendered
            // otherwise .PDFViewPageChanged will be invoked many times.
            if let lastPage = Int(self.lastPage) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.goCurrentPage(page: lastPage)
                }
            }
        }
    }
    
    private func start() {
        let nc = NotificationCenter.default
                    
        nc.addObserver(forName: .PDFViewDocumentChanged, object: nil, queue: nil) { event in
            guard let pdfView = event.object as? PDFView else { return }
            guard let document = pdfView.document else { return }

            print("debug: ", "PDFViewDocumentChanged: ", self.lastPage)
            self.store.pageCount = document.pageCount
        }
        
        nc.addObserver(forName: .PDFViewPageChanged, object: nil, queue: nil) { event in
            guard let pdfView = event.object as? PDFView else { return }
            guard let currentPage = pdfView.currentPage else { return }
            guard let document = pdfView.document else { return }

            let page = document.index(for: currentPage)

            print("debug: ", "PDFViewPageChanged: ", page + 1, document.pageCount)
            self.store.currentPage = String(page + 1)
            self.lastPage = String(page + 1)
        }

        nc.addObserver(forName: .PDFViewSelectionChanged, object: nil, queue: nil) { _ in
            let text = PDFKitViewRepresentable.getSelectedText()
            if text != "" {
                self.store.selectedText = text
            }
        }
        
        willCurrentPageChanged = self.store.$currentPage
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { page in
                guard let page = Int(page) else { return }
                print("debug: ", "willCurrentPageChanged: ", page)
                self.goCurrentPage(page: page)
            }
        
        //TODO: [Fix PDFView issue] PDFView will not correctly set the last page after SwiftUI reshows it.
        willViewModeChanged = self.store.$mode
            .receive(on: RunLoop.main)
            .sink { mode in
                if mode == .pdf {
                    if let page = Int(self.store.currentPage) {
                        print("debug: ", "willViewModeChanged: ", page)
                        self.goCurrentPage(page: page)
                    }
                }
            }
        
        
        print("debug: ", "Bundle.main.url: ", self.lastPage)
        self.url = Bundle.main.url(forResource: "FunctionalSwift", withExtension: "pdf")
    }
    
    private func goCurrentPage(page: Int) {
        guard let document = PDFKitViewRepresentable.pdfView.document else { return }

        print("debug: ", "goCurrentPage:", page)
        if let page = document.page(at: page - 1) {
            PDFKitViewRepresentable.pdfView.go(to: page)
        }
    }
}

private struct PDFKitViewRepresentable: UIViewRepresentable {
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

