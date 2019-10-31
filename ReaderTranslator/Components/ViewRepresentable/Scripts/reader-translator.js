(function() {
    var keysStatus = {}

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

    function _send(name, source, e, text) {
        text = text || document.getSelection().toString().trim()
        let sourceValue = (document.querySelector("#source") || {}).value
        let entryValue = (document.querySelector("#entry") || {}).value
        let event = {
            time: Date(), // to prevent removing duplicate events
            name: name,
            source: source,
            extra: {
                ctrlKey: e.ctrlKey || keysStatus.ctrlKey,
                altKey: e.altKey || keysStatus.altKey,
                metaKey: e.metaKey || keysStatus.metaKey, //⌘ Command
                shiftKey: e.shiftKey || keysStatus.shiftKey,
                which: e.which || keysStatus.which,
                keyCode: e.keyCode || keysStatus.keyCode,
                selectedText: text || sourceValue || entryValue,
            }
        }
 
        if(window.safari && safari.extension) {
            safari.extension.dispatchMessage(JSON.stringify(event))
         }else{
            webkit.messageHandlers.send.postMessage(JSON.stringify(event))
         }
    }
 
    let sendIn100 = debounce(_send, 100)
    let sendIn500 = debounce(_send, 500)
    let sendIn1000 = debounce(_send, 1000)

    document.addEventListener("DOMContentLoaded", (event) => {
        //disabled: sometimes this event occurs after press keys
//        send({name: 'DOMContentLoaded', source: 'document'})
    })

    document.addEventListener("mousedown", (event) => {
        keysStatus = event
    })

    document.addEventListener("mouseup", (event) => {
        keysStatus = {}
    })

    document.addEventListener('selectionchange', (event) => {
        let selection = document.getSelection()
                              
        //Reverso selects text in `search-input` tag after the page loaded
        if(document.getSelection().focusNode.id == 'search-input') return
                              
        if(selection.toString().trim()) {
            sendIn1000('selectionchange', 'document', event)
        }
    })

    window.addEventListener('keydown', (event) => {
        if(event.ctrlKey || event.altKey) sendIn500('keydown', 'window', event)
    })


    //Apple videos
    document.addEventListener("DOMContentLoaded", (event) => {
        if(!location.href.includes('https://developer.apple.com/videos/')) return

        let video = document.querySelector('video')
        let lastElm

        video.ontimeupdate = function() {
            let time = parseInt(video.currentTime)
            let elm = document.querySelector(`[href$="?time=${time}"]`)
            if(elm) {
                if(lastElm) lastElm.style.color = ""
                elm.style.color="yellow"
                lastElm = elm
            }
        }

        window.addEventListener('keydown', (event) => {
            let tagName = event.target.tagName.toLocaleLowerCase()
            if(['textarea', 'input'].includes(tagName)) return

            if(event.key == 'p') {
                video.paused ? video.play() : video.pause()
                return
            }
            if(event.key == 't') {
                sendIn1000('selectionchange', 'document', event, lastElm.text.trim())
                return
            }
            if(event.key == 'ArrowLeft') {
                if(lastElm) lastElm.style.color = ""
                lastElm = lastElm.previousElementSibling
                lastElm.click()
                video.play()
                return
            }
        })
    })
 })()
