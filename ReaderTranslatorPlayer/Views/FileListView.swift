//
//  FileListView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import AVFoundation

var player: AVAudioPlayer?

struct FileListView: View {
    @ObservedObject var store = Store.shared

    @State var files: [URL] = []

    init() {
        do {
            let sharedInstance = AVAudioSession.sharedInstance()

            try sharedInstance.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try sharedInstance.setActive(true)
        } catch {
            print(error)
        }
    }

    var body: some View {
        List {
            ForEach(files, id: \.self) { url in
                Button(action: {
                    self.store.lastAudio = url
                    self.openAudio(url: url)
                    self.store.isPlaying = true
                }, label: {
                    Text("\(url.lastPathComponent)")
                    .foregroundColor(
                        self.store.lastAudio?.lastPathComponent == url.lastPathComponent ? Color.yellow: Color.primary)
                })
            }
            .onDelete { indexSet in
                guard let first = indexSet.first else { return }
                let file = self.files[first]
                do {
                    try FileManager.default.removeItem(at: file)
                    self.refresh()
                } catch {
                    print(error)
                }
            }
        }
        .onAppear {
            RunLoop.main.perform {
                self.refresh()
            }
            if let lastAudio = self.store.lastAudio { self.openAudio(url: lastAudio) }
        }
    }

    private func refresh() {
       guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.files = []
            return
       }

       do {
           let inbox = documentsUrl.appendingPathComponent("/Inbox")
           let items = try FileManager.default.contentsOfDirectory(at: inbox, includingPropertiesForKeys: nil)

           self.files = items
       } catch {
           print(error)
           self.files = []
       }
    }

    private func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.rate = store.audioRate
        } catch {
            print(error)
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView()
    }
}
