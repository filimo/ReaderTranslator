//
//  CambridgeStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/3/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import Combine
import Foundation
import SwiftSoup
import SwiftUI

private var cancellable: AnyCancellable?

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
    private func addAudio(selector: String, document: Document) -> Bool {
        do {
            guard let elm = try document.select(selector).first else { return false }
            let string = try elm.attr("src")
            guard let url = URL(string: "https://dictionary.cambridge.org/\(string)") else { return false }

            AudioStore.shared.addAudio(url: url)
            return true
        } catch {
            Logger.log(type: .error, value: error)
        }
        return false
    }
}
