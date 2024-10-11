//
//  ContentView.swift
//  ReaderTranslatorSafari
//
//  Created by Viktor Kushnerov on 26.12.23.
//  Copyright © 2023 Viktor Kushnerov. All rights reserved.
//

import SafariServices
import SwiftUI

struct ContentView: View {
    @AppStorage("ExtentionSafariLanguage")
    var language: String = "ru"

    var body: some View {
        VStack {
            HStack {
                Text("Language")
                TextField("Language", text: $language)
                    .frame(width: 20)
            }
            
            Button("Google Translate") {
                Task {
                    Task {
                        guard let window = await SFSafariApplication.activeWindow(),
                              let tab = await window.activeTab(),
                              let page = await tab.activePage(),
                              let properties = await page.properties(),
                              let url = properties.url?.absoluteString
                        else { return }
                        
                        self.translate(url, in: tab)
                    }
                }
            }
            
            Button("300.ya.ru") {
                Task {
                    let service = "https://300.ya.ru"
                    guard let window = await SFSafariApplication.activeWindow(),
                          let tab = await window.activeTab(),
                          let page = await tab.activePage(),
                          let properties = await page.properties(),
                          let url = properties.url?.absoluteString
                    else { return }
                    
                    //                    copyToClipboard(url)
                    
                    if let tab = await window.openTab(with: URL(string: service)!, makeActiveIfPossible: true),
                       let page = await tab.activePage()
                    {
                        let script = """
                            document.getElementsByTagName('textarea')[0].value = "\(url)"
                        """
                        
                        let userInfo = ["scriptToExecute": script]
                        
                        try await Task.sleep(nanoseconds: 500_000_000)
                        page.dispatchMessageToScript(withName: "executeScript", userInfo: userInfo)
                    }
                }
            }
        }
        
        Button("YTranslate") {
            Task {
                let service = "https://translate.yandex.ru/translate"
                guard let window = await SFSafariApplication.activeWindow(),
                      let tab = await window.activeTab(),
                      let page = await tab.activePage(),
                      let properties = await page.properties(),
                      let url = properties.url?.absoluteString
                else { return }
                
                //                    copyToClipboard(url)
                
                if let tab = await window.openTab(with: URL(string: service)!, makeActiveIfPossible: true),
                   let page = await tab.activePage()
                {
                    let script = """
                        document.getElementById('urlInput-input').value = "\(url)"
                    """
                    
                    let userInfo = ["scriptToExecute": script]
                    
                    try await Task.sleep(nanoseconds: 500_000_000)
                    page.dispatchMessageToScript(withName: "executeScript", userInfo: userInfo)
                }
            }
        }
        .padding()
    }
}

private extension ContentView {
    func translate(_ url: String, in tab: SFSafariTab?) {
        let translateURL = "http://translate.google.com/translate?hl=\(language)&sl=auto&tl=\(language)&u=\(url)"
        guard let url = URL(string: translateURL) else { return }

        tab?.navigate(to: url)
    }

    func copyToClipboard(_ url: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(url, forType: .string)
    }
}
