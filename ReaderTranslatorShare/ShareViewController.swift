//
//  ShareViewController.swift
//  ReaderTranslatorShare
//
//  Created by Viktor Kushnerov on 18/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import Social
import SwiftUI
import UIKit

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        guard let inputItems = self.extensionContext?.inputItems else { return }
        guard let itemProvider = inputItems.first as? NSExtensionItem else { return }
        guard let attachment = itemProvider.attachments?.first else { return }
        
        let controller = UIHostingController(rootView: PreviewView())
        
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        controller.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { item, _ in
            guard let sentence = item as? String else { return }
            
            RunLoop.main.perform {
                Store.shared.sentence = sentence
            }
        }
    }
}
