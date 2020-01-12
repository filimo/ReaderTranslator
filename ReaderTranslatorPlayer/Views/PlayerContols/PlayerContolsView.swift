//
//  PlayerContolsView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var audioStore = AudioStore.shared

    @State var showSafari = false
    @State var showHosts = false
    @State var showTimer = false

    var body: some View {
        VStack(spacing: 10) {
            Text("\(audioStore.timelineStatus)")
            AudioRateView()
            RewindButtonsView()
            HStack(spacing: 20) {
                timerButton
                hostsButton
                Spacer()
                playPauseButton
                safariButton
            }.padding([.leading, .trailing], 20)
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: .constant(URL(string: "https://www.ldoceonline.com")))
        }
        .sheet(isPresented: $showHosts) { ConnectionView() }
        .actionSheet(isPresented: $showTimer) {
            ActionSheet(
                title: Text("Sleep timer"),
                message: Text(self.audioStore.remainTimerTime),
                buttons: timerValueButtons
            )
        }
    }

    private var playPauseButton: some View {
        Button(
            action: {
                self.audioStore.saveAllAudioPlayer()
                self.audioStore.isPlaying.toggle()
            },
            label: { Text(audioStore.isPlaying ? "Pause" : "Play") }
        ).buttonStyle(RoundButtonStyle())
    }

    private var timerButton: some View {
        Button(
            action: { self.showTimer = true },
            label: { Image(systemName: "timer") }
        ).buttonStyle(RoundButtonStyle())
    }

    private var hostsButton: some View {
        Button(
            action: { self.showHosts = true },
            label: { Image(systemName: "wifi") }
        ).buttonStyle(RoundButtonStyle())
    }

    private var safariButton: some View {
        Button(
            action: { self.showSafari = true },
            label: { Text("Safari") }
        ).buttonStyle(RoundButtonStyle())
    }

    private var timerValueButtons: [ActionSheet.Button] {
        Array(-1...20).map { val in
            if val == -1 { return .cancel() }

            let minutes = val * 10
            let value = minutes == 0 ? "Off" : String(describing: minutes)
            let action = {
                if minutes == 0 {
                    self.audioStore.stopSleepTimer()

                } else { self.audioStore.setSleepTimer(minutes: minutes) }
            }
            return .default(Text("\(value)"), action: action)
        }
    }
}

struct PlayerContolsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView()
    }
}
