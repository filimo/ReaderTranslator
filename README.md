# ReaderTranslator 
**using SwiftUI, Combine and Catalyst for MacOS(Catalyst and AppKit) iPad iPhone**

## Requirements
- macOS 10.15 Catalina
- iOS 13

## How to install on macOS
- Download **ReaderTranslatorMac.dmg** from https://github.com/filimo/ReaderTranslator/releases
- Open downloaded **ReaderTranslatorMac.dmg**
- Copy **ReaderTranslatorMac** to **Applications** folder
- Open **ReaderTranslatorMac** by the right click and click **Open** button (might require two attempts) 
- Enable **ReaderTranslatorSafari** extension in Safari->Preferences->Extensions

## Important
If you want to translate selected text from Safari you should enable ReaderTranslatorSafari extension in Safari preferences
![](files/important_1.png)

Catalyst project for macOS has some problems:
- Select a text in `WKWebView`
- Handle key events
- Support Safari extension

iOS project seems less useful as it has a small screen to fit 3 views.
iPadOS project takes place to exist but I don't have iPad now. I going to buy it with a pencil and continue experimenting with usability.

If you want to run the project on macOS I recommend to use 'ReaderTranslatorMac' target. I keep to support Catalyst version for macOS but nowadays it has some unfixed issues noted above.

## Comming features in 1.5
Open selected text in Collins, MacMillan, Longman dictionaries, Wikipedia. 

## Status
While I am waiting for the commercial **SwiftUI** projects I decided to dedicate my free time to build this open-source project.

## Base idea

> “If you can’t explain it simply, you don’t understand it well enough.” 
> by Albert Einstein

Since I read a lot of books or articles in a foreign language I periodically turn to Google Translate and Reverso
to understand unfamiliar idioms, words or to find a sutable expressions or words in my native language.
And I like to listen to how a word or sentence is pronounced through the voice engine of the system or Google Translate and Reverso.
Although this process is simple I would like to make it as more comfortable as possible.
Sometimes I am lazy to look into the translator and I make an assumption about the meaning of a word or idiom and it can lead to a missunderstanding which turns into even greater loss of my time.
Another useful feature is to write text in Safari to check and listen to it with a simple selection of text.

## Features
- Support MacOS, ipadOS, iOS
- Read PDF books or Web pages
- Translate selected words or sentences through *Google Translate* and *Reverso*
- Voice words or sentences though voice engines with rate speech, *Google Translate* and *Reverso*
- Adjust speech rate

## Goals
Explore features, limitations and bugs *SwiftUI, Combine and Catalyst*.


## Releases
**1.4**
 - Open selected text by service menu items in Safari and GTranslator [#40](https://github.com/filimo/ReaderTranslator/issues/40)

![](files/Release_1.4_1.png)
![](files/Release_1.4_2.png)

You are curious about why same text are opened in both GTranslator and Safari. There are two reasons.
First you can select a particular sentence in GTranslator to translate it in Reverso.
Second you can select a particular sentence in Safari to translate it in GTranslator.

**1.3.7**
- Build `ReaderTranslatorMac.dmg` . You can find them [here](https://github.com/filimo/ReaderTranslator/releases) 

**1.3.6**
- If there isn't selected text in GTranslator then text is spoken from input tag
- If there isn't selected text in Reverso then text is spoken from textarea tag

![](files/Release_1.3.6_1.png)
![](files/Release_1.3.6_2.png)

**1.3.5**
- [Bookmarks for favorite sentences](https://github.com/filimo/ReaderTranslator/issues/42)  
![](files/Release_1.3.5.png)

**1.3.4**
- Add button to Reverso to speak text by Reverso
- Add button to GTranslator to speak text by Reverso

**1.3.2**
- Fix: Crash the app when switching between view modes
- Fix: Translate/Speak selected text in WebPage

**1.3.0**
Support *Reverso Context* [features](https://github.com/filimo/ReaderTranslator/issues/19)
![](files/Release_1.3.0_1.png)
![](files/Release_1.3.0_2.png)
![](files/Release_1.3.0_3.png)

New WebKit architecture [issue](https://github.com/filimo/ReaderTranslator/issues/27)
<pre><code>
           ┌────────────────┐                                  ┌────────────────┐
           │                │                                  │                │
           │      View      │────────openSafari───────────────▶│     Safari     │
           │                │                                  │                │
           └────────────────┘                                  └────────────────┘
           │                │
           │                │
       makeView        updateView                                    ┌──────────────────────┐
           │                │                                        │                      │
           ▼                ▼                   ┌───────────────────▶│        WKPage        │
           ┌────────────────┐                   │                    │                      │
           │                │               makeView                 └──────────────────────┘
           │ WKPepresenter  │───────────────────┘                    │           │          ▲
           │                │                ┌──────────────────┐    │           │          │
           └────────────────┘──makeView      │  WKScriptsSetup  │    │           │          │
                                    └───────▶│                  │ create        ┌┘   goBack handler
            ┌───────────────────────┐        └──────────────────┘    │        load          │
            │     WKCoordinator     │                  │             │          │           │
            │                       │                  │             ▼          │           │
            └───────────────────────┘                  │             ┌──────────▼───────────┐
            ▲           ▲                              │             │      WKWebView       │
            │           │                              └──setup─────▶│                      │
            │           │                                            └──────────────────────┘
            │           │              ┌────────────────────────┐    │           │
            │           │              │ WKScriptMessageHandler │    │           │
            │           └──────────────│                        │◀───┘           │
            ┌──────────────────────┐   └────────────────────────┘                │
            │ WKNavigationDelegate │                                             │
            │                      │◀──────────────────────────navigation events─┘
            └──────────────────────┘
</code></pre>

### TranslateAction [here](https://github.com/filimo/ReaderTranslator/wiki/Diagrams)

```swift
enum TranslateAction: Equatable {
    case none(text: String = "")
    case reverso(text: String)
    case translator(text: String, noReverso: Bool = false)
    
    func getText() -> String {
        switch self {
        case .none(let text): return text
        case .reverso(let text): return text
        case .translator(let text, _): return text
        }
    }
    
    mutating func setNone() {
        self = .none(text: getText())
    }
}
```
![](files/diagram-selected-text.jpg)


**1.2** Implemented Safari extension. You can read about coming features [here](https://github.com/filimo/ReaderTranslator/issues/15) and review [here](https://github.com/filimo/ReaderTranslator/tree/%2315_safari_plugin). It's very intresting case when we need to make commnication between the app and extentions.
![](files/Release_1.2_1.png)


**You can help** me if you look at the list of [open bugs](https://github.com/filimo/ReaderTranslator/issues/).

![DEMO](files/demo.gif)

![](files/Screen10.png)
![](files/Screen8.png)
![](files/Screen9.png)
![](files/Screen1.png)
![](files/Screen2.png)
![](files/Screen3.png)
![](files/Screen4.png)
![](files/Screen5.png)
![](files/Screen6.png)
![](files/Screen7.png)
