//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Foundation

struct AudioPlayer {
    var player: AVAudioPlayer?
    var rate: Float = 1 {
        willSet {
            player?.rate = newValue
        }
    }

    var rateString: String {
        String(format: "%.1f", arguments: [rate])
    }

    var status: String {
        guard let player = player else { return "" }
        return String(format: "%.1f/%.1f", player.currentTime, player.duration)
    }

    mutating func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        player?.enableRate = true
    }
}
