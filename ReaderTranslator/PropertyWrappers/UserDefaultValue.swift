//
//  UserDefaultValue.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/13/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

@propertyWrapper
class UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
