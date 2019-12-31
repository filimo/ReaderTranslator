//
//  AudioStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import SwiftUI

var PREVIEW_MODE: Bool = false

final class AudioStore: NSObject, ObservableObject {
    static let shared = AudioStore()

    private var timer: Timer?
    private var sleepTimer: Timer?
    private(set) var player: AVAudioPlayer?
    private var someObservationContext = ""

    @Published var currentStatus = "0.0/0.0"
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
                stopSleepTimer()
            }
        }
    }

    @Published(wrappedValue: nil, key: "lastAudio") var lastAudio: URL?
    @Published(key: "isVoiceEnabled") var isEnabled = true
    @Published(key: "voiceVolume") var volume: Float = 1
    @Published(key: "audioRate") var rate: Float = 1
    @Published var sleepAfter = 0

    private override init() {
        super.init()

        do {
            let sharedInstance = AVAudioSession.sharedInstance()

            try sharedInstance.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try sharedInstance.setActive(true)
        } catch {
            Logger.log(type: .error, value: error)
        }
        
        if player == nil {
            if let lastAudio = lastAudio { openAudio(url: lastAudio) }
        }
    }
}

extension AudioStore {
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
        sleepTimer = Timer.scheduledTimer(withTimeInterval: Double(minutes * 50), repeats: false) { _ in
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

extension AudioStore {
    func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.delegate = self
            player.enableRate = true
            player.rate = rate
            lastAudio = url
        } catch {
            print(error)
        }
    }
}

extension AudioStore: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            guard let url = FileStore.shared.nextFile(file: lastAudio) else {
                isPlaying = false
                return
            }
            openAudio(url: url)
            isPlaying = true
        }
    }
}
