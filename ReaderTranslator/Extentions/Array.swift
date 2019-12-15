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

    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size)
            .map {
                Array(self[$0 ..< Swift.min($0 + size, count)])
            }
    }
}
