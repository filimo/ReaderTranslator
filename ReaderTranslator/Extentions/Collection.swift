//
//  Collection.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
