//
//  BackgroundButtonStyle.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

public struct RoundButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.blue)
            .padding(5)
            .blur(radius: configuration.isPressed ? 4 : 0)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.blue)
                    
        )
    }
}
