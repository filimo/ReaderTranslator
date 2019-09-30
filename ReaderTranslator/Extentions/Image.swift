//
//  Image.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/30/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI

#if os(macOS)
struct Image: View {
    let symbol: String
    
    init(systemName: String) {
        self.symbol = [
            "speaker": "􀊠",
            "speaker.fill": "􀊩",
            "star": "􀑭",
            "star.fill": "􀋃"
        ][systemName] ?? ""
    }
    
    var body: some View {
        Text(symbol)
    }
}
#endif
