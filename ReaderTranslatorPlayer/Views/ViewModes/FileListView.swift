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
    @ObservedObject var fileStore = FileStore.shared
    @ObservedObject var audioStore = AudioStore.shared
    @State var files = FileStore.shared.files

    var body: some View {
        List {
            ForEach(audioStore.allAudioPlayers, id: \.url) { player in
                self.buttonView(player)
            }
            .onDelete { indexSet in
                guard let first = indexSet.first else { return }
                guard let url = self.audioStore.allAudioPlayers[first].url else { return }
                
                do {
                    try FileManager.default.removeItem(at: url)
                    self.audioStore.saveAllAudioPlayer()
                } catch {
                    Logger.log(type: .error, value: error)
                }
            }
        }
    }

    private func buttonView(_ player: AVAudioPlayer) -> some View {
        guard let url = player.url else { return EmptyView().any }

        return Button(action: {
            self.audioStore.play(url)
        }, label: {
            Text("\(url.lastPathComponent)")
                .foregroundColor(self.getColor(url: url))
        }).any
    }

    private func getColor(url: URL) -> Color {
        audioStore.lastAudio?.lastPathComponent == url.lastPathComponent ? Color.yellow : Color.primary
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        PREVIEW_MODE = true

        return FileListView()
    }
}
