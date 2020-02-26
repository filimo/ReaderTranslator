//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import SwiftUI

final class Store: ObservableObject {
    private init() {}
    static var shared = Store()

    let maxViewWidth: CGFloat = 400

    @Published(key: "canSafariSendSelectedText") var canSafariSendSelectedText: Bool = true {
        didSet {
            ViewsStore.shared.enableView(view: .safari, enable: canSafariSendSelectedText)
        }
    }
    @Published var translateAction = TranslateAction()
}
