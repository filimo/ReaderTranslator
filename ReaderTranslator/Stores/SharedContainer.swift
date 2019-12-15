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
    private static let bundleIdentifier = "by.filimo.ReaderTranslatorMac"
    private static var appIdentifierPrefix: String? = {
        Bundle.main.infoDictionary!["AppIdentifierPrefix"] as? String
    }()

    static let sharedDefaults: UserDefaults? = {
        guard let appIdentifierPrefix = appIdentifierPrefix else { return nil }
        return UserDefaults(suiteName: "\(appIdentifierPrefix)\(bundleIdentifier)")
    }()

    static func getEvent() -> DOMEvent? {
        if let string = sharedDefaults?.string(forKey: key) {
            do {
                return try JSONDecoder().decode(DOMEvent.self, from: Data(string.utf8))
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    static func setEvent(string: String) {
        sharedDefaults?.set(string, forKey: key)
    }
}
