//
//  AudioStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import MediaPlayer
import SwiftUI

final class AudioStore: NSObject, ObservableObject {
    static let shared = AudioStore()

    private var timer: Timer?
    private var sleepTimer: Timer?
    private(set) var player: AVAudioPlayer?
    private var someObservationContext = ""

    private static var directoryObserver: DirectoryObserver?

    @Published private(set) var allAudioPlayers = [AVAudioPlayer]()

    @Published var timelineStatus = "0.0/0.0"
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
    @Published(key: "audioRate") var rate: Float = 1 {
        didSet {
            setupNowPlaying()
        }
    }

    @Published var sleepAfter = 0

    private override init() {
        super.init()

        initDirectoryObserver()
        initAudioSesssion()
        saveAllAudioPlayer()
        initMPRemoteCommandCenter()

        if let lastAudio = lastAudio { openAudio(url: lastAudio) }
    }
}

extension AudioStore {
    private func initDirectoryObserver() {
        if let url = FileStore.shared.folderUrl {
            Self.directoryObserver = DirectoryObserver(URL: url) {
                RunLoop.main.perform { self.saveAllAudioPlayer() }
            }
        }
    }
    
    private func initAudioSesssion() {
        do {
            let sharedInstance = AVAudioSession.sharedInstance()

            try sharedInstance.setCategory(.playback, mode: .default, options: .init(rawValue: 0))
            try sharedInstance.setActive(true)
        } catch {
            Logger.log(type: .error, value: error)
        }
    }
    
    func updateTimeline(timer _: Timer? = nil) {
        guard let player = self.player else { return }
        timelineStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
    }
}

extension AudioStore {
    func openAudio(url: URL?) {
        guard let url = url else { return }

        if player != nil { player?.pause() }
        player = allAudioPlayers.first { $0.url == url }
        guard let player = player else { return }
        player.rate = rate
        player.delegate = self
        player.enableRate = true
        lastAudio = url
    }

    func play(_ url: URL? = nil) {
        guard let url = url ?? lastAudio else {
            isPlaying = false
            return
        }
        openAudio(url: url)
        isPlaying = true
        setupNowPlaying()
    }

    func prevPlay() {
        guard let index = (allAudioPlayers.firstIndex { $0.url == player?.url }) else { return }
        if index == 0 { return }
        play(allAudioPlayers[index - 1].url)
    }

    func nextPlay() {
        guard let index = (allAudioPlayers.firstIndex { $0.url == player?.url }) else { return }
        if allAudioPlayers.indices.contains(index + 1) == false { return }
        play(allAudioPlayers[index + 1].url)
    }

    func saveAllAudioPlayer() {
        allAudioPlayers = FileStore.shared.files
            .compactMap { url in
                do {
                    return try AVAudioPlayer(contentsOf: url)
                } catch {
                    Logger.log(type: .error, value: (error, url))
                }
                return nil
            }
    }
}

extension AudioStore: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextPlay()
        }
    }
}

extension AudioStore {
    private func initMPRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { _ in
            self.prevPlay()
            return .success
        }

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ in
            self.isPlaying = true
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ in
            self.isPlaying = false
            return .success
        }

        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { _ in
            self.nextPlay()
            return .success
        }
    }

    private func setupNowPlaying() {
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPMediaItemPropertyTitle] = player?.url?.lastPathComponent
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension AudioStore {
    func invalidate() {
        timer?.invalidate()
    }

    func startTimer() {
        invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: updateTimeline(timer:))
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
