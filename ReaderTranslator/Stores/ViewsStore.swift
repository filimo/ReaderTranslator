//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import CoreGraphics

final class ViewsStore: ObservableObject {
    private init() {}
    static let shared = ViewsStore()

    static let defaultWidth: CGFloat = 500

    @Published(key: "enabledViews") var enabledViews: Set<AvailableView> = [.reverso, .gTranslator]
    @Published(key: "viewWidth") var viewWidth: [AvailableView: CGFloat] = [:]
    @Published(key: "viewOrder") var viewOrder: [AvailableView: Int] = [:]

    @Published var showSettings = false
}

extension ViewsStore {
    static var enabledSafari: Bool {
        Self.shared.enabledViews.contains(.safari)
    }
    
    static func toggleSafari() {
        let status = Self.shared.enabledViews.contains(.safari)
        Self.shared.enableView(view: .safari, enable: !status)
    }
    
    func enableView(view: AvailableView, enable: Bool) {
        if enable {
            enabledViews.insert(view)
        } else {
            enabledViews.remove(view)
        }
    }

    func toggleView(view: AvailableView) {
        let enabled = enabledViews.contains(view)
        enableView(view: view, enable: !enabled)
    }
}
