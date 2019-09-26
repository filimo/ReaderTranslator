//
//  String.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/26/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
