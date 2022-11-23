//
//  FavoriteVoiceName.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/27/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct FavoriteVoiceName: Identifiable, Codable {
    var id = UUID()
    var language: String
    var voice: String
}

