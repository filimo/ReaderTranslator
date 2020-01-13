//
//  NumberFormatter.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 13/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import Foundation


extension NumberFormatter {
    static var localInt: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    static var localCGFloat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    static var localFloat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
