//
//  Image.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/30/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI

#if os(macOS)
    extension Image {
        static func sfSymbol(_ systemName: String) -> some View {
            Image(systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .colorInvert()
                .frame(height: 20)
        }
    }
#else
extension Image {
    static func sfSymbol(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .colorInvert()
            .frame(height: 20)
    }
}
#endif

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        Image.sfSymbol("square.and.arrow.down.fill")
    }
}
