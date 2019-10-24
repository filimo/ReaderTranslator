//
//  NSObject.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 24/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
