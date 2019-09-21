//
//  UserDefault.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/21/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    private let defaultValue: Value
    
    init(wrappedValue defaultValue: Value, key: String) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
