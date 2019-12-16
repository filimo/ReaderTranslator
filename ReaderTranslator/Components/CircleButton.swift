//
//  CircleButton.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 17/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct CircleButton<Content>: View where Content: View {
    var content: () -> Content

    var body: some View {
        Circle()
            .stroke()
            .overlay(GeometryReader { geometry in
                self.content()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            })
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton { Text("77") }
    }
}
