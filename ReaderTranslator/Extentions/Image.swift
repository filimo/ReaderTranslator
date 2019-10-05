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
            "volume.3.fill": "􀊩",
            "star": "􀋂",
            "star.fill": "􀋃",
            "arrowshape.turn.up.left": "􀉌",
            "arrowshape.turn.up.left.fill": "􀉍",
            "safari": "􀎬",
            "doc.on.clipboard": "􀉃",
            "xmark.circle": "􀁠",
            "1.circle": "􀀺",
            "1.circle.fill": "􀀻",
            "2.circle": "􀓭",
            "2.circle.fill": "􀔌",
            "3.circle": "􀀾",
            "3.circle.fill": "􀀿",
            "minus.magnifyingglass": "􀊭",
            "plus.magnifyingglass": "􀊬"
        ][systemName] ?? ""
    }
    
    var body: some View {
        Text(symbol)
    }
}
#endif
