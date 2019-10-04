//
//  SharedContenner.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct SharedContainer {
    private static let key = "SharedContainer.Message"
    static let sharedDefaults: UserDefaults? =  {
        let appIdentifierPrefix = Bundle.main.infoDictionary!["AppIdentifierPrefix"] as! String
        let bundleIdentifier = "by.filimo.ReaderTranslatorMac"
        
        return UserDefaults(suiteName: "\(appIdentifierPrefix)\(bundleIdentifier)")
    }()

    static func getEvent() -> DOMEvent? {
        if let string = sharedDefaults?.string(forKey: key) {
            do {
                return try JSONDecoder().decode(DOMEvent.self, from: Data(string.utf8))
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func setEvent(string: String) {
        let appIdentifierPrefix = Bundle.main.infoDictionary!["AppIdentifierPrefix"] as! String
        let bundleIdentifier = "by.filimo.ReaderTranslatorMac"
        
        UserDefaults(suiteName: "\(appIdentifierPrefix)\(bundleIdentifier)")?.set(string, forKey: key)
    }
}
