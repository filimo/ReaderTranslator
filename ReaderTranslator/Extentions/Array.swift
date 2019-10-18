//
//  Array.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 18/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
}
