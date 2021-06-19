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

private var cancellable: AnyCancellable?

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
    @Published var word = ""

    @Published var sentences: LongmanSentences = [] {
        didSet {
            print("longmanSentences: ", sentences)
        }
    }

    private let defaultURL = "https://www.ldoceonline.com/dictionary/"

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

                    let isBreExist = self.addAudio(selector: ".brefile", document: document)
                    let isAmeExist = self.addAudio(selector: ".amefile", document: document)
                    
                    RunLoop.main.perform {
                        self.sentences.removeAll()
                        self.addSentences(document: document)
                    }

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
