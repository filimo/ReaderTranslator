//
//  Stack.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct Stack<Element> {
    private var items = [Element]()

    var value: Element? { items.first }
    var count: Int { items.count }
    
    mutating func push(_ item: Element) { items.append(item) }

    mutating func pop() -> Element? {
        guard items.isEmpty == false else { return nil }
        return items.removeFirst()
    }

    mutating func removeAll() {
        items.removeAll()
    }
}
