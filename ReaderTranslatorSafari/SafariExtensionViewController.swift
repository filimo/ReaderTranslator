//
//  SafariExtensionViewController.swift
//  ReaderTranslatorSafari
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SafariServices
import SwiftUI



class SafariExtensionViewController: SFSafariExtensionViewController {
    static let shared = SafariExtensionViewController()

    private var hostingController: NSHostingController<ContentView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = ContentView()
        hostingController = NSHostingController(rootView: contentView)

        if let hostingView = hostingController?.view {
            view.addSubview(hostingView)
            hostingView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: view.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}
