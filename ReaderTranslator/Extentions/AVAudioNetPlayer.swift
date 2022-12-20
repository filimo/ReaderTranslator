//
//  AVAudioPlayer.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import AVFoundation

class AVAudioNetPlayer {
    public var delegate: AVAudioNetPlayerDelegate?
    private var player: AVAudioPlayer?

    func play(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: self.load).resume()
    }

    private func load(data: Data?, response: URLResponse?, error: Error?) {
        guard let data = data else {
            Logger.log(value: (response?.url, error))
            self.delegate?.audioPlayerLoadErrorDidOccur()
            return
        }
        self.delegate?.audioPlayerLoadDidFinishDidOccur()
        self.createAVAudioPlayer(data: data)
    }

    private func createAVAudioPlayer(data: Data) {
        do {
            self.player = try AVAudioPlayer(data: data)

            if let player = self.player {
                player.delegate = self.delegate
                self.delegate?.audioPlayerCreateSuccessOccur(player: player)
            }
        } catch {
            Logger.log(value: error)
            self.delegate?.audioPlayerCreateErrorDidOccur()
        }
    }
}

protocol AVAudioNetPlayerDelegate: AVAudioPlayerDelegate {
    func audioPlayerLoadDidFinishDidOccur()
    func audioPlayerLoadErrorDidOccur()

    func audioPlayerCreateSuccessOccur(player: AVAudioPlayer)
    func audioPlayerCreateErrorDidOccur()

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
