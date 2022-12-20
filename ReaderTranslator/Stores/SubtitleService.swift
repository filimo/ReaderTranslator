//
//  SubtitleService.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20.12.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import Combine
import Foundation

final class SubtitleService: ObservableObject {
    static let shared = SubtitleService()

    @Published(key: "subtitles") var subtitles: [Subtitle] = []
    @Published var selectedLines: [Int: String] = [:]

    var subtitleServicePublisher: some Publisher<[Int: String], Never> {
        $selectedLines.debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
    }

    var timerPublisher: some Publisher<Date, Never> {
        Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    }

    func parseSRT(srt: String) -> [Subtitle] {
        let lines = srt.components(separatedBy: "\n")
        var subtitles: [Subtitle] = []
        var currentSubtitle: Subtitle?

        for line in lines {
            // Check if the line is a subtitle index
            if let index = Int(line) {
                // If we already have a subtitle, add it to the array
                // and start a new one
                if let subtitle = currentSubtitle {
                    subtitles.append(subtitle)
                }
                currentSubtitle = Subtitle(id: index, start: 0, end: 0, text: "")
            } else if currentSubtitle != nil {
                // Check if the line is a timestamps line
                let parts = line.split(separator: " --> ")
                if parts.count == 2 {
                    let startString = String(parts[0])
                    let endString = String(parts[1])
                    if let start = parseTimestamp(timestamp: startString), let end = parseTimestamp(timestamp: endString) {
                        currentSubtitle?.start = start
                        currentSubtitle?.end = end
                    }
                } else {
                    // If it's not a timestamps line, it must be the subtitle text
                    currentSubtitle?.text += line + " "
                }
            }
        }
        // Don't forget to add the last subtitle
        if let subtitle = currentSubtitle {
            subtitles.append(subtitle)
        }

        return subtitles
    }

    func parseTimestamp(timestamp: String) -> Double? {
        let parts = timestamp.split(separator: ":")

        if parts.count == 3 {
            let hours = Double(parts[0]) ?? 0
            let minutes = Double(parts[1]) ?? 0
            let secondsAndMilliseconds = parts[2].split(separator: ",")
            let seconds = Double(secondsAndMilliseconds[0]) ?? 0
            let milliseconds = Double(secondsAndMilliseconds[1]) ?? 0

            return (hours * 3600) + (minutes * 60) + seconds + (milliseconds / 1000)
        }

        return nil
    }
}
