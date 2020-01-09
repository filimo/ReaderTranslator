//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class ViewsStore: ObservableObject {
    private init() {}
    static let shared = ViewsStore()

    @Published(key: "enabledViews") var enabledViews: Set<AvailableView> = [.reverso, .gTranslator]
    @Published(key: "viewWidth") var viewWidth: [AvailableView: CGFloat] = [:]
    @Published(key: "viewOrder") var viewOrder: [AvailableView: Int] = [:]
}
