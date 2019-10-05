//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/4/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct DOMEvent: Decodable, Equatable {
    struct Extra: Decodable, Equatable {
        let ctrlKey: Bool?
        let altKey: Bool?
        let metaKey: Bool? /* Returns a Boolean that is true if the Meta key
                              (on Mac keyboards, the ⌘ Command key;
                              on Windows keyboards, the Windows key (⊞))
                              was active when the key event was generated.*/
        let shiftKey: Bool?
        let which: Int?   /* Returns a Number representing a system and implementation dependent numeric
                              code identifying the unmodified value of the pressed key; this is usually the same as keyCode. */
        let keyCode: Int?
        
        
        let selectedText: String?
    }
    
    let name: String
    let source: String
    let extra: Extra?
}
