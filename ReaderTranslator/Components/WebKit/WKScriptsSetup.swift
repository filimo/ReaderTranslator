//
//  ViewRepresentableJavaScriptDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import WebKit

private let script = """
(function() {
    function debounce(func, wait, immediate) {
      // 'private' variable for instance
      // The returned function will be able to reference this due to closure.
      // Each call to the returned function will share this common timer.
      var timeout;

      // Calling debounce returns a new anonymous function
      return function() {
        // reference the context and args for the setTimeout function
        var context = this,
          args = arguments;

        // Should the function be called now? If immediate is true
        //   and not already in a timeout then the answer is: Yes
        var callNow = immediate && !timeout;

        // This is the basic debounce behaviour where you can call this
        //   function several times, but it will only execute once
        //   [before or after imposing a delay].
        //   Each time the returned function is called, the timer starts over.
        clearTimeout(timeout);

        // Set the new timeout
        timeout = setTimeout(function() {

          // Inside the timeout function, clear the timeout variable
          // which will let the next execution run when in 'immediate' mode
          timeout = null;

          // Check if the function already ran with the immediate flag
          if (!immediate) {
            // Call the original function with apply
            // apply lets you define the 'this' object as well as the arguments
            //    (both captured before setTimeout)
            func.apply(context, args);
          }
        }, wait);

        // Immediate mode and no wait timer? Execute the function..
        if (callNow) func.apply(context, args);
      }
    }

    function _send(method, value) {
        webkit.messageHandlers[method].postMessage(value)
    }

    var sendIn100 = debounce(_send, 100)
    var sendIn1000 = debounce(_send, 1000)

    document.onselectionchange = function() {
        var txt = document.getSelection().toString()
        
        sendIn1000('onSelectionChange', txt)
    }
    window.oncontextmenu = function() {
        var txt = document.getSelection().toString()
        
        sendIn100('onContextMenu', txt)
    }
    document.body.onload = function() {
        sendIn100('onBodyLoaded', '')
    }
    document.body.onkeydown = function(event) {
        sendIn100('onKeyDown', event.keyCode)
    }
})()
"""

protocol WKScriptsSetup {
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!)
    func goBack(_ webView: WKPageView)
}

extension WKScriptsSetup {
    func setupScripts<T: WKCoordinator>(view: WKPageView, coordinator: T) where T: WKScriptMessageHandler {
        let userContentController = view.configuration.userContentController

        userContentController.add(coordinator, name: "onSelectionChange")
        userContentController.add(coordinator, name: "onContextMenu")
        userContentController.add(coordinator, name: "onBodyLoaded")
        userContentController.add(coordinator, name: "onKeyDown")
        
        #if os(macOS)
        view.allowsMagnification = true
        #endif
        view.navigationDelegate = coordinator
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(userScript)
    }
    
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!) {}
    func goBack(_ webView: WKPageView) {}
}

