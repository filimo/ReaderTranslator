//
//  AVAudioPlayer.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
//    private func play(url: URL) -> AVAudioPlayer? {
//        var player: AVAudioPlayer?
//
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let data = data else { return }
//            do {
//                if AudioStore.shared.isEnabled {
//                    player = try AVAudioPlayer(data: data)
//                    if let player = player {
//                        player.play()
//                    }
//                }
//            } catch {
//                self.delegate?.audioPlayerCreateErrorDidOccur()
//            }
//        }.resume()
//    }

}


extension AVAudioPlayerDelegate {
    func audioPlayerCreateErrorDidOccur() {
        Logger.log()
    }
}
