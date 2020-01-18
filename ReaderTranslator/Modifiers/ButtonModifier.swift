//
//  ButtonModifier.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 18/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
            .fixedSize(horizontal: true, vertical: false)
            .padding([.top, .bottom], 8)
    }
}
