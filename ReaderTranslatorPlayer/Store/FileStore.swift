//
//  FileStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 31/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class FileStore: ObservableObject {
    private init() {}
    static let shared = FileStore()
    
    var files: [URL] {
        guard let url = folderUrl else { return [] }

        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            Logger.log(type: .error, value: error)
            return []
        }
    }

    let folderUrl: URL? = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsUrl.appendingPathComponent("/Inbox")
    }()
    
    func prevFile(file: URL?) -> URL? {
        guard let file = file else { return nil }
        guard let current = files.firstIndex(of: file) else { return nil }
        
        return files.indices.contains(current - 1) ? files[current - 1] : nil
    }

    func nextFile(file: URL?) -> URL? {
        guard let file = file else { return nil }
        guard let current = files.firstIndex(of: file) else { return nil }
        
        return files.indices.contains(current + 1) ? files[current + 1] : nil
    }
}

