//
//  PDFKitRepresentedView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/8/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    @State var url: URL?

    @EnvironmentObject var store: Store

    var body: some View {
        PDFKitViewRepresentable(url: $url)
        .onAppear {
            self.start()
            
            // TODO: [Fix PDFView issue] Set the current page after PDFView is rendered
            // otherwise .PDFViewPageChanged will be invoked many times.
            if let lastPage = Int(self.store.lastPdfPage) {
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

            print("debug: ", "PDFViewDocumentChanged: ", self.store.lastPdfPage)
            self.store.pageCount = document.pageCount
        }
        
        nc.addObserver(forName: .PDFViewPageChanged, object: nil, queue: nil) { event in
            guard let pdfView = event.object as? PDFView else { return }
            guard let currentPage = pdfView.currentPage else { return }
            guard let document = pdfView.document else { return }

            let page = document.index(for: currentPage)

            print("debug: ", "PDFViewPageChanged: ", page + 1, document.pageCount)
            self.store.currentPage = String(page + 1)
            self.store.lastPdfPage = String(page + 1)
        }

        nc.addObserver(forName: .PDFViewSelectionChanged, object: nil, queue: nil) { _ in
            let text = PDFKitViewRepresentable.getSelectedText()
            if text != "" {
                self.store.selectedText = text
            }
        }
        
        _ = self.store.$currentPage
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { page in
                guard let page = Int(page) else { return }
                print("debug: ", "willCurrentPageChanged: ", page)
                self.goCurrentPage(page: page)
            }
        
        //TODO: [Fix PDFView issue] PDFView will not correctly set the last page after SwiftUI reshows it.
        _ = self.store.$viewMode
            .receive(on: RunLoop.main)
            .sink { mode in
                if mode == .pdf {
                    if let page = Int(self.store.currentPage) {
                        print("debug: ", "willViewModeChanged: ", page)
                        self.goCurrentPage(page: page)
                    }
                }
            }
        
        
        print("debug: ", "Bundle.main.url: ", store.lastPdfPage)
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




