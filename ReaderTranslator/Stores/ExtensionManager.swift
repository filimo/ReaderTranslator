//
//  ExtensionListener.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/3/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

class SafariExtensionManager {
    typealias onMessageChangedType = (_ name: String) -> ()

    static private let center = CFNotificationCenterGetDarwinNotifyCenter()
    
    static private let domainName = "by.filimo.ReaderTranslatorMac.ReaderTranslatorSafari"
    static private let notificationName = "onMessagedChanged"
    static private var eventName: CFString { "\(domainName).\(notificationName)" as CFString }
        
    private var onMessageChanged: onMessageChangedType?
    
    func start(onMessageChanged: @escaping onMessageChangedType) {
        self.onMessageChanged = onMessageChanged
        CFNotificationCenterAddObserver(Self.center, Unmanaged.passRetained(self).toOpaque(), callBack, Self.eventName, nil, .deliverImmediately)
    }
    
    deinit {
        CFNotificationCenterRemoveEveryObserver(Self.center, Unmanaged.passRetained(self).toOpaque())
    }
    
    private var callBack: CFNotificationCallback = { (_, observer, name, object, _) -> () in
        if let observer = observer, let name = name {
            let safariExtensionManagerSelf = Unmanaged<SafariExtensionManager>.fromOpaque(observer).takeUnretainedValue()
            safariExtensionManagerSelf.onMessageChanged?(name.rawValue as String)
        }
    }
    
    static func didMessageChanged() {
        CFNotificationCenterPostNotification(center, .init(eventName), nil, nil, true)
    }
}

