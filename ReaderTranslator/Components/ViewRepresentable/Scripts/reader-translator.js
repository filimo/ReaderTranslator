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
                playbackRate: (e.extra || {}).playbackRate
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
                    
        if(!selection) return
                              
        //Reverso selects text in `search-input` tag after the page loaded
        if(selection.focusNode.id == 'search-input') return
                              
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
    	let isVideoPaused = true

        function playVideo() {
        	isVideoPaused = false
        	video.play()
        }

        function pauseVideo() {
        	isVideoPaused = true
        	video.pause()
        }

        function lastElementSiblingInPreviousParagraph() {
        	let elm = lastElm.parentElement.previousElementSibling
            if(elm) return elm.lastElementChild
        	return lastElm
        }

        function previousElementSibling() {
            let elm = lastElm.previousElementSibling
            if(!elm) elm = lastElementSiblingInPreviousParagraph()
            if(elm) {
	            elm.style.color = "yellow"
	            lastElm = elm	
            	if(elm.previousElementSibling) {
	            	lastElm = elm = elm.previousElementSibling
		            elm.style.color = "yellow"
	        	}else{
	        		elm = undefined
	        	}
            }
            return elm
        }

        function getWholeSentence() {
        	return [...lastElm.parentElement.children]
                    .map(item=>{ return item.text.trim() })
                    .join(' ')
                    .match(/[^\.!\?]+[\.!\?]+/g)
                    .find(item=>item.includes(lastElm.text.trim()))
                    .trim()
        }
                              
        video.ontimeupdate = function() {
            let time = parseInt(video.currentTime)
            let elm = document.querySelector(`[href$="?time=${time}"]`)

            if(isVideoPaused) pauseVideo()
            if(elm) {
                if(lastElm) lastElm.style.color = ""
                elm.style.color="yellow"
                elm.scrollIntoViewIfNeeded()
                lastElm = elm
            }
        }

        window.addEventListener('keydown', (event) => {
            let tagName = event.target.tagName.toLocaleLowerCase()
            if(['textarea', 'input'].includes(tagName)) return

            if(event.keyCode == 191) { // '?' key
                event.preventDefault()
                if(video.paused) {
                    sendIn100('stop', 'video', event, '')
                    if(lastElm) lastElm.click()
                    playVideo()
                }else{
                    let text = lastElm.text.trim()
                    sendIn100('selectionchange', 'document', event, text)
                    pauseVideo()
                }
                return false
        	}

            if(event.keyCode == 190) { // '>' key
            }
            if(event.keyCode == 188) { // '<' key
                event.preventDefault()
                
				pauseVideo()
                let elm = previousElementSibling()
                while(true) {
                	if(!elm) {
                		elm = lastElm
                		break
                	}
                	if(elm) {
                		lastElm = elm
                		elm.style.color="yellow"
                        if(elm.text.includes(".") || elm.text.includes("!") || elm.text.includes("?")) {
                            elm = elm.nextElementSibling
                            if(elm) {
                            	elm.style.color="yellow"
                            	lastElm = elm
                            }
                            break
                        }
                	}
                	elm = elm.previousElementSibling
                }
                lastElm.click()
                             
                sendIn100('selectionchange', 'document', event, getWholeSentence())
                return false
            }
            if(event.key == 'ArrowLeft') {
                event.preventDefault()
				
                if(!lastElm) return
				pauseVideo()

				if(!event.shiftKey) lastElm.style.color=""
	            let elm = lastElm.previousElementSibling
	            if(!elm) elm = lastElementSiblingInPreviousParagraph()
	            if(elm) {
	            	if(event.shiftKey) {
	            		sendIn100('addNewPhraseBefore', 'document', event, elm.text.trim())
	            	}else{
	                	sendIn100('selectionchange', 'document', event, elm.text.trim())
	            	}
	            	lastElm = elm
	            	lastElm.click()
	        	}
                return false
            }
            if(event.key == 'ArrowRight') {
                event.preventDefault()
				
                if(!lastElm) return
				pauseVideo()

				if(!event.shiftKey) lastElm.style.color=""
                if(lastElm.nextElementSibling) {
                    lastElm = lastElm.nextElementSibling
                }else{
		        	let elm = lastElm.parentElement.nextElementSibling
		            if(elm) lastElm = elm.firstElementChild
                }
            	if(event.shiftKey) {
            		sendIn100('addNewPhraseAfter', 'document', event, lastElm.text.trim())
            	}else{
                	sendIn100('selectionchange', 'document', event, lastElm.text.trim())
            	}
                lastElm.click()
                return false
            }
            if(event.keyCode == 187) { // "+" key
                event.preventDefault()
                
				pauseVideo()
                video.playbackRate += 0.05
                event.extra = { playbackRate: video.playbackRate}
                sendIn100('playbackRate', 'video', event)
            }
            if(event.keyCode == 189) { // "-" key
                event.preventDefault()
            
				pauseVideo()
                video.playbackRate -= 0.05
                event.extra = { playbackRate: video.playbackRate}
                sendIn100('playbackRate', 'video', event)
            }
        })
    })

    //Local videos
    document.addEventListener("DOMContentLoaded", (event) => {
        if(!location.href.includes('http://localhost:8080')) return

        let $video = document.querySelector('video')
        let $play = document.querySelector('#play')

        function play(event) {
            event.preventDefault()
            let $elm = document.querySelector('[current=true]')
            if($video.paused) {
                document.querySelector('[current=true]').click()
                $video.play()
                sendIn100('stop', 'video', event, '')
            }else{
                if($elm) {
                    let text = $elm.textContent.replace('\n', ' ')
                    sendIn100('selectionchange', 'document', event, text)
                    $video.pause()
                }
            }
        }
                     
        $play.addEventListener('click', event => play(event))                      
        window.addEventListener('keydown', event => {
            if(event.keyCode == 80) play(event) // 'p' key
            if(event.keyCode == 188) { // "<" key
                event.preventDefault()
                let $elm = document.querySelector('[current=true]')
                let $prevElm = $elm.previousElementSibling

                let text = `${($elm.prevElm || {}).textContent} ${$elm.textContent}`

                $video.pause()
                sendIn100('selectionchange', 'document', event, text)
                if($elm.previousElementSibling) $elm.previousElementSibling.click()
            }                
        })
    })
 })()
