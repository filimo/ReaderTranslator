# ReaderTranslator 
**using SwiftUI, Combine and Catalyst for MacOS(Catalyst and AppKit) iPad iPhone**

## Comming features in 1.4

## Status
While I am waiting for the commercial **SwiftUI** projects I decided to dedicate my free time to build this open-source project.

## Base idea
Since I read a lot of books or articles in a foreign language I periodically turn to Google Translate 
to understand unfamiliar idioms, words or to find a sutable expressions or words in my native language.
And I like to listen to how a word or sentence is pronounced through the voice engine of the system or Google Translate(or others services).
Although this process is simple I would like to make it as more comfortable as possible.
Sometimes I am lazy to look into the translator and I make an assumption about the meaning of a word or idiom and it can lead to a missunderstanding which turns into even greater loss of my time.

## Features
- Support MacOS, ipadOS, iOS
- Read PDF books or Web pages
- Translate selected words or sentences through *Google Translate*
- Voice words or sentences though voice engines with rate speech
- Adjust speech rate

## Goals
Explore features, limitations and bugs *SwiftUI, Combine and Catalyst*.


## Releases
**1.3**

Support *Reverso Context* [features](https://github.com/filimo/ReaderTranslator/issues/19)
<img src="https://github.com/filimo/ReaderTranslatorfiles/Screen12.png" height="400px"/>
<img src="https://github.com/filimo/ReaderTranslatorfiles/Screen13.png" height="400px"/>
<img src="https://github.com/filimo/ReaderTranslatorfiles/Screen14.png" height="400px"/>

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
<pre><code>
### `TranslateAction`
```swift
enum TranslateAction: Equatable {
    case none
    case reversoContext(text: String)
    case translator(text: String, noReversoContext: Bool = false)
    
    func getText() -> String {
        switch self {
        case .none: return ""
        case .reversoContext(let text): return text
        case .translator(let text, _): return text
        }
    }
}
```
<img src="https://github.com/filimo/ReaderTranslator/blob/master/files/diagram-selected-text.jpg" height="400px"/>


**1.2** Implemented Safari extension. You can read about coming features [here](https://github.com/filimo/ReaderTranslator/issues/15) and review [here](https://github.com/filimo/ReaderTranslator/tree/%2315_safari_plugin). It's very intresting case when we need to make commnication between the app and extentions.
![](files/Screen11.png)


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
