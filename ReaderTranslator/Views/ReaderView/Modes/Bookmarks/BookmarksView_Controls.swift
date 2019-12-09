//
//  BookmarksView_List.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView_Controls: View {
    @ObservedObject var store = Store.shared

    @State var showConfirm = false

    private var audioRateString: String {
        String(format: "%.1f", arguments: [self.store.longmanAudioRate])
    }

    var body: some View {
        VStack {
            HStack {
                Text("\(store.bookmarks.checked.count)/\(store.bookmarks.count)")
                actionMenuView
            }
            audioRateButtonsView
        }
        .alert(isPresented: $showConfirm) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Remove all bookmarks?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Ok")) {  self.store.bookmarks.removeAll() })
        }
    }

    private var audioRateButtonsView: some View {
        HStack {
            Button(action: { self.store.longmanAudioRate = 0.2 }, label: { Text(".2") })
            Button(action: { self.store.longmanAudioRate = 0.5 }, label: { Text(".5") })
            Button(action: { self.store.longmanAudioRate -= 0.1 }, label: { Text("-") })
            Text(audioRateString)
            Button(action: { self.store.longmanAudioRate += 0.1 }, label: { Text("+") })
            Button(action: { self.store.longmanAudioRate = 1 }, label: { Text("1") })
        }
    }

    private var actionMenuView: some View {
        MenuButton("Actions") {
            Button(action: {
                Clipboard.copy(self.store.bookmarks.joined(separator: "\n"))
            }, label: { Text("Copy bookmarks to Clipboard") })
            Button(action: {
                let items = Clipboard.string.split(separator: .BackslashN)
                self.store.bookmarks.append(items: items)
            }, label: { Text("Paste bookmarks separated by \\n from Clipboard") })
            Button(action: {
                self.showConfirm = true
            }, label: { Text("Remove all bookmarks") })
        }
        .fixedSize()
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .padding([.leading, .trailing], 5)
        .background(RoundedRectangle(cornerRadius: 3).foregroundColor(Color(NSColor.controlColor)))

    }
}

struct BookmarksView_Controls_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Controls()
    }
}
