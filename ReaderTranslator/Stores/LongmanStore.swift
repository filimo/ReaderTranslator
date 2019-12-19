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
private var player: AVAudioPlayer?

struct LongmanSentence: Hashable {
    static let empty = Self(text: "No sentences", url: URL.empty)

    let text: String
    let url: URL
}

typealias LongmanSentences = [LongmanSentence]

class LongmanStore: NSObject {
    static let share = LongmanStore()

    @ObservedObject var store = Store.shared

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

                self.next()
            } catch {
                print(error)
            }
        }.resume()
    }

    func addAudio(url: URL) {
        audioUrls.push(url)
    }

    private func addSentences(document: Document) {
        do {
            let sentences = try document.select(".exafile")
            sentences.forEach { elm in
                do {
                    let string = try elm.attr("data-src-mp3")
                    guard let url = URL(string: string) else { return }
                    guard let text = try elm.parent()?.text() else { return }

                    RunLoop.main.perform {
                        self.store.bookmarks.longmanSentences.append(.init(text: text, url: url))
                    }
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }

    private func addAudio(selector: String, document: Document) {
        do {
            guard let elm = try document.select(selector).first else { return }
            let string = try elm.attr("data-src-mp3")
            guard let url = URL(string: string) else { return }

            addAudio(url: url)
        } catch {
            print(error)
        }
    }

    private func play(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                player = try AVAudioPlayer(data: data)
                player?.delegate = self
                player?.enableRate = true
                player?.rate = self.store.longmanAudioRate
                player?.volume = self.store.voiceVolume
                player?.play()
            } catch {
                self.next()
                print("\(self.theClassName)_\(#function)", error)
            }
        }.resume()
    }

    func next() {
        if audioUrls.count == 0 { return }
        play(url: audioUrls.pop())
    }
}

extension LongmanStore: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        next()
    }

    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) {
        next()
    }
}
