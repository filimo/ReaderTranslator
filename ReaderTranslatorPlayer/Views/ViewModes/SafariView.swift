//
//  SafariView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 1/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariRepresentable: UIViewControllerRepresentable {
    @Binding var url: URL

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController,
                                context _: Context) {}
}

struct SafariView: View {
    @Binding var url: URL?
    private static var view: SafariRepresentable?

    var body: some View {
        Group {
            if url != nil {
                SafariRepresentable(url: Binding($url)!)
            } else {
                EmptyView()
            }
        }
    }
}
