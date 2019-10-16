//
//  Set.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 15/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine

extension Set where Element: AnyCancellable {
    mutating func cancelAndRemoveAll() {
        self.forEach { $0.cancel() }
        self.removeAll()
    }
}
