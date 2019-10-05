//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#else
typealias ViewRepresentable = UIViewRepresentable
#endif
