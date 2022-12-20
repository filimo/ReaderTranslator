//
//  Subtitle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20.12.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct Subtitle: Identifiable, Codable {
    let id: Int
    var start: Double
    var end: Double
    var text: String
}
