//
//  FileListView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Dispatch
import SwiftUI

struct FileListView: View {
    var debug: Bool

    @ObservedObject var audioStore = AudioStore.shared

    static var directoryObserver: DirectoryObserver?

    init(debug: Bool = false) {
        self.debug = debug
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
            ForEach(audioStore.files, id: \.self) { url in
                Button(action: {
                    self.audioStore.lastAudio = url
                    self.audioStore.openAudio(url: url)
                    self.audioStore.isPlaying = true
                }, label: {
                    Text("\(url.lastPathComponent)")
                        .foregroundColor(self.getColor(url: url))
                })
            }
            .onDelete { indexSet in
                guard let first = indexSet.first else { return }
                let file = self.audioStore.files[first]
                do {
                    try FileManager.default.removeItem(at: file)
//                    self.refresh()
                } catch {
                    print(error)
                }
            }
        }
        .onAppear {
            if let url = self.folderUrl {
                RunLoop.main.perform {
                    if self.debug {
                        self.audioStore.files = [Bundle.main.bundleURL.appendingPathComponent("test audio")]
                    } else {
                        self.refresh()
                    }
                }
                Self.directoryObserver = DirectoryObserver(URL: url) { self.refresh() }
            }
            if self.audioStore.player == nil {
                if let lastAudio = self.audioStore.lastAudio { self.audioStore.openAudio(url: lastAudio) }
            }
        }
    }

    private let folderUrl: URL? = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsUrl.appendingPathComponent("/Inbox")
    }()

    private func getColor(url: URL) -> Color {
        audioStore.lastAudio?.lastPathComponent == url.lastPathComponent ? Color.yellow : Color.primary
    }

    private func refresh() {
        audioStore.files = []
        guard let url = folderUrl else { return }

        do {
            let items = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

            audioStore.files = items
        } catch {
            print(error)
            audioStore.files = []
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView(debug: true)
    }
}
