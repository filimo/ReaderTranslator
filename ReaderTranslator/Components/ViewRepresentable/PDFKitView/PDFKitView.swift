//
//  PDFKitRepresentedView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/8/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import PDFKit
import SwiftUI

private var cancellableSet: Set<AnyCancellable> = []
private var pdfViewDocumentChangedObserver: NSObjectProtocol?
private var pdfViewPageChangedObserver: NSObjectProtocol?
private var pdfViewSelectionChangedObserver: NSObjectProtocol?

struct PDFKitView: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var pdfStore = PdfStore.shared

    var selectedText = PassthroughSubject<String, Never>()

    var body: some View {
        PDFKitViewRepresentable(url: $pdfStore.lastPdf)
            .onAppear {
                pdfViewDocumentChangedObserver = NotificationCenter.default.addObserver(
                    forName: .PDFViewDocumentChanged,
                    object: nil,
                    queue: nil,
                    using: self.pdfViewDocumentChanged
                )
                pdfViewPageChangedObserver = NotificationCenter.default.addObserver(
                    forName: .PDFViewPageChanged,
                    object: nil,
                    queue: nil,
                    using: self.pdfViewPageChanged
                )
                pdfViewSelectionChangedObserver = NotificationCenter.default.addObserver(
                    forName: .PDFViewSelectionChanged,
                    object: nil,
                    queue: nil,
                    using: self.pdfViewSelectionChanged
                )

                self.selectedText
                    .debounce(for: 0.1, scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink { text in
                        self.store.translateAction.addAll(text: text)
                    }
                    .store(in: &cancellableSet)

                // TODO: [Fix PDFView issue] Set the current page after PDFView is rendered
                // otherwise .PDFViewPageChanged will be invoked many times.
                if let lastPage = Int(self.pdfStore.lastPdfPage) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.goCurrentPage(page: lastPage)
                    }
                }
            }
            .onDisappear {
                cancellableSet.cancelAndRemoveAll()
                NotificationCenter.default.removeObserver(pdfViewDocumentChangedObserver as Any)
                NotificationCenter.default.removeObserver(pdfViewPageChangedObserver as Any)
                NotificationCenter.default.removeObserver(pdfViewSelectionChangedObserver as Any)
            }
    }

    private func start() {
        pdfStore.$currentPdfPage
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { page in
                guard let page = Int(page) else { return }
                print("debug: ", "willCurrentPageChanged: ", page)
                self.goCurrentPage(page: page)
            }
            .store(in: &cancellableSet)

        print("debug: ", "Bundle.main.url: ", pdfStore.lastPdfPage)
    }

    private func goCurrentPage(page: Int) {
        guard let document = PDFKitViewRepresentable.pdfView.document else { return }

        print("debug: ", "goCurrentPage:", page)
        if let page = document.page(at: page - 1) {
            PDFKitViewRepresentable.pdfView.go(to: page)
        }
    }

    private func pdfViewDocumentChanged(event: Notification) {
        guard let pdfView = event.object as? PDFView else { return }
        guard let document = pdfView.document else { return }

        print("debug: ", "PDFViewDocumentChanged: ", pdfStore.lastPdfPage)
        pdfStore.pageCount = document.pageCount
    }

    private func pdfViewPageChanged(event: Notification) {
        guard let pdfView = event.object as? PDFView else { return }
        guard let currentPage = pdfView.currentPage else { return }
        guard let document = pdfView.document else { return }

        let page = document.index(for: currentPage)

        print("debug: ", "PDFViewPageChanged: ", page + 1, document.pageCount)
        pdfStore.currentPdfPage = String(page + 1)
        pdfStore.lastPdfPage = String(page + 1)
    }

    private func pdfViewSelectionChanged(event _: Notification) {
        let text = PDFKitViewRepresentable.getSelectedText()
        if text != "" { selectedText.send(text) }
    }
}
