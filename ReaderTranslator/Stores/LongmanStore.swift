//
//  Longman.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Combine
import Foundation
import SwiftSoup
import SwiftUI

private var cancellableSet: Set<AnyCancellable> = []
private var player: AVAudioNetPlayer?

struct LongmanSentence: Hashable {
    static let empty = Self(text: "No sentences", url: URL.empty)

    let text: String
    let url: URL
}

typealias LongmanSentences = [LongmanSentence]

final class LongmanStore: NSObject, ObservableObject {
    private override init() { super.init() }
    static var shared = LongmanStore()

    @Published var audioRate: Float = 1
    @Published var word = "" {
        willSet {
            sentences.removeAll()
            LongmanStore.shared.fetchInfo(text: newValue)
        }
    }

    @Published var sentences: LongmanSentences = [] {
        didSet {
            print("longmanSentences: ", sentences)
        }
    }

    private let defaultURL = "https://www.ldoceonline.com/dictionary/"
    private var audioUrls = Stack<URL>()

    func fetchInfo(text: String) {
        let text = text.replacingOccurrences(of: " ", with: "-")
        guard let url = URL(string: "\(defaultURL)\(text)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let document = try SwiftSoup.parse(html)

                self.addAudio(selector: ".brefile", document: document)
                self.addAudio(selector: ".amefile", document: document)
                self.addSentences(document: document)

                self.play()
            } catch {
                Logger.log(type: .error, value: error)
            }
        }.resume()
    }
}

extension LongmanStore {
    private func addSentences(document: Document) {
        do {
            let sentences = try document.select(".exafile")

            let longmanSentences = sentences.map { elm -> LongmanSentence? in
                do {
                    let string = try elm.attr("data-src-mp3")
                    guard let url = URL(string: string) else { return nil }
                    guard let text = try elm.parent()?.text() else { return nil }

                    return LongmanSentence(text: text, url: url)
                } catch {
                    Logger.log(type: .error, value: error)
                    return nil
                }
            }.compactMap { $0 }
            RunLoop.main.perform {
                self.sentences = longmanSentences
            }
        } catch {
            Logger.log(type: .error, value: error)
        }
    }

    func addAudio(url: URL) {
        audioUrls.push(url)
    }

    private func addAudio(selector: String, document: Document) {
        do {
            guard let elm = try document.select(selector).first else { return }
            let string = try elm.attr("data-src-mp3")
            guard let url = URL(string: string) else { return }

            addAudio(url: url)
        } catch {
            Logger.log(type: .error, value: error)
        }
    }
}

extension LongmanStore {
    func play() {
        guard let url = audioUrls.pop() else { return }

        if AudioStore.shared.isEnabled {
            player = AVAudioNetPlayer()
            player?.delegate = self
            player?.play(url: url)
        }
    }
}

extension LongmanStore: AVAudioNetPlayerDelegate {
    func audioPlayerLoadDidFinishDidOccur() {}

    func audioPlayerCreateSuccessOccur(player: AVAudioPlayer) {
        player.enableRate = true
        player.rate = audioRate
        player.volume = AudioStore.shared.volume
        player.play()
    }

    func audioPlayerLoadErrorDidOccur() { play() }
    func audioPlayerCreateErrorDidOccur() { play() }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) { play() }
    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) { play() }
}
