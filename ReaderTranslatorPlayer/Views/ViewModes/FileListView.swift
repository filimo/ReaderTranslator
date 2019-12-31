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

    var body: some View {
        List {
            ForEach(fileStore.files, id: \.self) { url in
                Button(action: {
                    self.audioStore.openAudio(url: url)
                    self.audioStore.isPlaying = true
                }, label: {
                    Text("\(url.lastPathComponent)")
                        .foregroundColor(self.getColor(url: url))
                })
            }
            .onDelete { indexSet in
                guard let first = indexSet.first else { return }
                let file = self.fileStore.files[first]
                do {
                    try FileManager.default.removeItem(at: file)
                } catch {
                    print(error)
                }
            }
        }
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
