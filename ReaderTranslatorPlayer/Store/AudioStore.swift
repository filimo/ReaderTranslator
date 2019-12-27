//
//  AudioStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import SwiftUI

final class AudioStore: NSObject, ObservableObject {
    private override init() { super.init() }
    static var shared = AudioStore()

    private var timer: Timer?
    private var sleepTimer: Timer?
    private(set) var player: AVAudioPlayer?
    private var someObservationContext = ""

    @Published var currentStatus = "0.0/0.0"
    @Published var files: [URL] = []
    @Published var isPlaying = false {
        willSet {
            guard let player = player else { return }

            if newValue {
                let currentTime = player.currentTime
                player.play()
                player.currentTime = currentTime
                startTimer()
            } else {
                player.pause()
                invalidate()
            }
        }
    }

    @Published(wrappedValue: nil, key: "lastAudio") var lastAudio: URL?
    @Published(key: "isVoiceEnabled") var isEnabled = true
    @Published(key: "voiceVolume") var volume: Float = 1
    @Published(key: "audioRate") var rate: Float = 1
    @Published var sleepAfter = 0
}

extension AudioStore {
    func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.delegate = self
            player.enableRate = true
            player.rate = rate
        } catch {
            print(error)
        }
    }

    func invalidate() {
        timer?.invalidate()
    }

    func startTimer() {
        invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let player = self.player else { return }
            self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
        }
    }
    
    func setSleepTimer(minutes: Int) {
        sleepTimer = Timer.scheduledTimer(withTimeInterval: Double(minutes), repeats: false) { _ in
            self.isPlaying = false
        }
    }
    
    func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
    }
    
    var remainTimerTime: String {
        guard let fireDate = self.sleepTimer?.fireDate else { return "The timer is off" }
        let time = RelativeDateTimeFormatter().localizedString(for: fireDate, relativeTo: Date())
        return "The timer will turn off \(time)"
    }
}

extension AudioStore: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            guard let lastAudio = lastAudio else { return }
            guard let current = files.firstIndex(of: lastAudio) else { return }
            let next = files.index(after: current)
            if files.indices.contains(next) {
                let url = files[next]
                openAudio(url: url)
                isPlaying = true
            }
        }
    }
}
