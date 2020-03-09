//
//  CambridgeStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/3/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Combine
import Foundation
import SwiftSoup
import SwiftUI

private var cancellable: AnyCancellable?
private var player: AVAudioNetPlayer?

struct CambridgeSentence: Hashable {
    static let empty = Self(text: "No sentences", url: URL.empty)

    let text: String
    let url: URL
}

typealias CambridgeSentences = [CambridgeSentence]

final class CambridgeStore: NSObject, ObservableObject {
    private override init() { super.init() }
    static var shared = CambridgeStore()

    @Published var audioRate: Float = 1
    @Published var word = ""

    private let defaultURL = "https://dictionary.cambridge.org/dictionary/english-russian/"
    private var audioUrls = Stack<URL>()

    func fetchInfo(text: String) -> AnyPublisher<Bool, Never> {
        let text = text.encodeUrl
        guard let url = URL(string: "\(defaultURL)\(text)") else {
            return Just(false).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                guard let html = String(data: $0.data, encoding: .utf8) else { return false }
                do {
                    let document = try SwiftSoup.parse(html)

                    self.audioUrls.removeAll()
                    let isBreExist = self.addAudio(selector: ".uk [type='audio/mpeg']", document: document)
                    let isAmeExist = self.addAudio(selector: ".us [type='audio/mpeg']", document: document)
                    
                    return isBreExist || isAmeExist
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

extension CambridgeStore {
    func addAudio(url: URL) {
        audioUrls.push(url)
    }

    private func addAudio(selector: String, document: Document) -> Bool {
        do {
            guard let elm = try document.select(selector).first else { return false }
            let string = try elm.attr("src")
            guard let url = URL(string: "https://dictionary.cambridge.org/\(string)") else { return false }

            addAudio(url: url)
            return true
        } catch {
            Logger.log(type: .error, value: error)
        }
        return false
    }
}

extension CambridgeStore {
    func play() {
        guard let url = audioUrls.pop() else { return }

        if AudioStore.shared.isSpeakWords {
            player = AVAudioNetPlayer()
            player?.delegate = self
            player?.play(url: url)
        }
    }
}

extension CambridgeStore: AVAudioNetPlayerDelegate {
    func audioPlayerLoadDidFinishDidOccur() {}

    func audioPlayerCreateSuccessOccur(player: AVAudioPlayer) {
        player.enableRate = true
        player.rate = audioRate
        player.volume = AudioStore.shared.wordsVolume
        player.play()
    }

    func audioPlayerLoadErrorDidOccur() { play() }
    func audioPlayerCreateErrorDidOccur() { play() }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) { play() }
    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) { play() }
}
