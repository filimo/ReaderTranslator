//
//  RoundedEdge.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 18/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
