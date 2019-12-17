//
//  DirectoryObserver.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 15/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

class DirectoryObserver {
    private let fileDescriptor: CInt
    private var source: DispatchSourceProtocol?

    deinit {
        source?.cancel()
        close(fileDescriptor)
    }

    init(URL: URL, block: @escaping () -> Void) {
        fileDescriptor = open(URL.path, O_EVTONLY)
        if fileDescriptor != -1 {
            source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: .all,
                queue: DispatchQueue.global())
            source?.setEventHandler {
                block()
            }
            source?.resume()
        }
    }
}
