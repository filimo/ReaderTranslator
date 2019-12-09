//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioPlayer {
    var player: AVAudioPlayer?
    var rate: Float = 1 {
        willSet {
            self.player?.rate = newValue
        }
    }

    var rateString: String {
        String(format: "%.1f", arguments: [rate])
    }

    mutating func openAudio(url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        player?.enableRate = true
    }
}
