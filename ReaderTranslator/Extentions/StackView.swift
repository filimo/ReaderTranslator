//
//  Stack.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StackView<Content: View>: View {
    var arrange: Arrange
    private let content: () -> Content

    init(arrange: Arrange, @ViewBuilder content: @escaping () -> Content) {
        self.arrange = arrange
        self.content = content
    }

    var body: some View {
        Group {
            if arrange == .vertical {
                VStack {
                    content()
                }
            } else {
                HStack {
                    content()
                }
            }
        }
    }
}

extension StackView {
    enum Arrange {
        case vertical, horizontal
    }
}

struct Stack_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StackView(arrange: .vertical) {
                Text("vertical 1")
                Text("vertical 2")
            }
            StackView(arrange: .horizontal) {
                Text("horizontal 1")
                Text("horizontal 2")
            }
        }
    }
}
