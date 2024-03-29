//
//  CollinsStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 16.06.21.
//  Copyright © 2021 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Combine
import Foundation
import SwiftSoup

private var player: AVAudioNetPlayer?

@MainActor
final class CollinsStore: NSObject, ObservableObject {
    static var shared = CollinsStore()

    private let defaultURL = "https://www.collinsdictionary.com/dictionary/english/"

    func fetchInfo(text: String) async -> Bool {
        do {
            let text = text.replacingOccurrences(of: " ", with: "-")

            guard let url = URL(string: "\(defaultURL)\(text)") else {
                return false
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return false }

            let document = try SwiftSoup.parse(html)

            let hasSound = self.addAudio(selector: ".hwd_sound.sound", document: document)

            return hasSound
        } catch {
            Logger.log(type: .error, value: error)
            
            return false
        }
    }
}

extension CollinsStore {
    private func addAudio(selector: String, document: Document) -> Bool {
        do {
            guard let elm = try document.select(selector).first else { return false }
            let string = try elm.attr("data-src-mp3")
            guard let url = URL(string: string) else { return false }

            AudioStore.shared.addAudio(url: url)
            return true
        } catch {
            Logger.log(type: .error, value: error)
        }
        return false
    }
}
