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

final class CollinsStore: NSObject, ObservableObject {
    static var shared = CollinsStore()

    private let defaultURL = "https://www.collinsdictionary.com/dictionary/english/"

    func fetchInfo(text: String) -> AnyPublisher<Bool, Never> {
        let text = text.replacingOccurrences(of: " ", with: "-")

        guard let url = URL(string: "\(defaultURL)\(text)") else {
            return Just(false).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                guard let html = String(data: $0.data, encoding: .utf8) else { return false }
                do {
                    let document = try SwiftSoup.parse(html)

                    Store.shared.audioUrls.removeAll()

                    let hasSound = self.addAudio(selector: ".hwd_sound.sound", document: document)

                    return hasSound
                } catch {
                    Logger.log(type: .error, value: error)
                }

                return false
            }
            .catch { _ in
                Just(false)
            }
            .eraseToAnyPublisher()
    }
}

extension CollinsStore {
    private func addAudio(selector: String, document: Document) -> Bool {
        do {
            guard let elm = try document.select(selector).first else { return false }
            let string = try elm.attr("data-src-mp3")
            guard let url = URL(string: string) else { return false }

            addAudio(url: url)
            return true
        } catch {
            Logger.log(type: .error, value: error)
        }
        return false
    }

    func addAudio(url: URL) {
        Store.shared.audioUrls.push(url)
    }
}

extension CollinsStore {
    func play() {
        guard let url = Store.shared.audioUrls.pop() else { return }

        if AudioStore.shared.isSpeakWords {
            player = AVAudioNetPlayer()
            player?.delegate = self
            player?.play(url: url)
        }
    }
}

extension CollinsStore: AVAudioNetPlayerDelegate {
    func audioPlayerLoadDidFinishDidOccur() {}

    func audioPlayerCreateSuccessOccur(player: AVAudioPlayer) {
        player.enableRate = true
        player.rate = LongmanStore.shared.audioRate
        player.volume = AudioStore.shared.wordsVolume
        player.play()
    }

    func audioPlayerLoadErrorDidOccur() { play() }
    func audioPlayerCreateErrorDidOccur() { play() }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) { play() }
    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) { play() }
}
