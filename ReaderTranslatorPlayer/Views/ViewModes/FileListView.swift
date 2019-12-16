//
//  FileListView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import SwiftUI

struct FileListView: View {
    @ObservedObject var store = Store.shared

    @State var files: [URL] = []

    static var player: AVAudioPlayer?
    static var directoryObserver: DirectoryObserver?

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
                        .foregroundColor(self.getColor(url: url))
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
            if let url = self.folderUrl {
                RunLoop.main.perform { self.refresh() }
                Self.directoryObserver = DirectoryObserver(URL: url) { self.refresh() }
            }
            if let lastAudio = self.store.lastAudio { self.openAudio(url: lastAudio) }
        }
    }

    private let folderUrl: URL? = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsUrl.appendingPathComponent("/Inbox")
    }()

    private func getColor(url: URL) -> Color {
        store.lastAudio?.lastPathComponent == url.lastPathComponent ? Color.yellow : Color.primary
    }

    private func refresh() {
        files = []
        guard let url = folderUrl else { return }

        do {
            let items = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

            files = items
        } catch {
            print(error)
            files = []
        }
    }

    private func openAudio(url: URL) {
        do {
            Self.player = try AVAudioPlayer(contentsOf: url)
            Self.player?.enableRate = true
            Self.player?.rate = store.audioRate
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