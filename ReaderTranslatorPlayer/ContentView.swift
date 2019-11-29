//
//  ContentView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 29/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import AVFoundation

private var player: AVAudioPlayer?

struct ContentView: View {
    @State var currentStatus = ""
    @State var isPlaying = false
    @State var audioRate: Float = 1 {
        didSet {
            player?.rate = audioRate
        }
    }
    private var files: [URL] {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        do {
            let inbox = documentsUrl.appendingPathComponent("/Inbox")
            let items = try FileManager.default.contentsOfDirectory(at: inbox, includingPropertiesForKeys: nil)
                                
            return items

        }catch{
            print(error)
            return []
        }
    }
    private var playPauseButton: some View {
        Button(action: {
            guard let player = player else { return }
            if self.isPlaying {
                player.pause()
            } else {
                //hack: currentTime jump forward for some time after an audio is continue to play
                let currentTime = player.currentTime
                player.play()
                player.currentTime = currentTime
            }
        }, label: { Text(isPlaying ? "Pause" : "Play ") })
    }
    
    private var audioRateView: some View {
        HStack {
            Button(action: { self.audioRate -= 0.1 }, label: { Text("-") }).padding(5)
            Text(String(format: "%.1f", arguments: [audioRate])).padding(5)
            Button(action: { self.audioRate += 0.1 }, label: { Text("+") }).padding(5)
        }
    }
    
    private var rewindView: some View {
        HStack {
            Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
            rewindButton(label: "-100", step: -100)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)
            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+100", step: 100)
        }
    }
    
    private var fileList: some View {
        List {
            ForEach(files, id: \.self) { file in
                Button(action: {
                    self.open(url: file)
                }, label: {
                    Text("\(file.lastPathComponent)")
                })
            }
        }
    }
    
    init() {
        do {
            let sharedInstance = AVAudioSession.sharedInstance()
            
            try sharedInstance.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try sharedInstance.setActive(true)
        }catch{
            print(error)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("\(currentStatus)").frame(width: 100)
            audioRateView
            rewindView
            playPauseButton
            fileList
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                guard let player = player else { return }
                self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
                self.isPlaying = player.isPlaying
            }
        }
    }
    
    private func open(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            self.audioRate = 1
        }catch{
            print(error)
        }
    }
    
    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: { player?.currentTime += step }, label: { Text(label) }).padding(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
