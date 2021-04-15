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

    function send(name, source, e, text) {
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
 
    let sendIn50 = debounce(send, 50)
    let sendIn100 = debounce(send, 100)
    let sendIn200 = debounce(send, 200)
    let sendIn500 = debounce(send, 500)
    let sendIn1000 = debounce(send, 1000)

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
 
    document.addEventListener("selectionchange", (event) => {
        if(location.hostname == "localhost" && location.pathname.includes('audiobooks')) return

        let selection = document.getSelection()
                    
        if(selection) {} else return
                              
        //Reverso selects text in `search-input` tag after the page loaded
        if(selection.focusNode.id == 'search-input') return
                              
        if(selection.toString().trim()) {
            sendIn1000('selectionchange', 'document', event)
        }
    })

    // // Use click event instead of selectionchange to avoid firing the event when using text search on a page
    // document.addEventListener('click', (event) => {
    //     if(location.hostname == "localhost" && location.pathname.includes('audiobooks')) return

    //     let selection = document.getSelection()
                    
    //     if(selection) {} else return
                              
    //     //Reverso selects text in `search-input` tag after the page loaded
    //     if(selection.focusNode.id == 'search-input') return
                              
    //     if(selection.toString().trim()) {
    //         send('selectionchange', 'document', event)
    //     }
    // })

    window.addEventListener('keydown', (event) => {
        if(event.ctrlKey || event.altKey) sendIn500('keydown', 'window', event)
    })


    //Apple videos
        if(!location.href.includes('https://developer.apple.com/videos/')) return

        let video = document.querySelector('video')
        let lastElm
    	let isVideoPaused = true

        let $playbackRate = document.createElement('span')
        document.querySelector('.footer-breadcrumbs').append($playbackRate)
        $playbackRate.innerHTML = "1.00"
                   
        function updateStatus() {
            let playbackRate = video.playbackRate.toFixed(2)
            let currentTime = video.currentTime.toFixed(0)
            let duration = video.duration.toFixed(0)

            $playbackRate.innerHTML = `playbackRate:${playbackRate} player:${currentTime}/${duration}`
        }

        function playVideo() {
        	isVideoPaused = false
            send('play', 'video', event, '')
        	video.play()
        }

        function pauseVideo() {
        	isVideoPaused = true
            send('pause', 'video', event, '')
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
	            lastElm = elm	
            	if(elm.previousElementSibling) {
	            	lastElm = elm = elm.previousElementSibling
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

        function getSelectedPhrases() {
            return [...document.querySelectorAll('[style="color: yellow;"]')]
            .map(elm => elm.text.trim())
            .join(' ')
        }

        function clearAllSelections() {
            document.querySelectorAll('[style="color: yellow;"]').forEach(elm => {
                elm.style.color = ""
            })
        }
                              
        video.ontimeupdate = function() {
            let time = parseInt(video.currentTime)
            let elm = [...document.querySelectorAll((`[href$="?time=${time}"]`))].reverse()[0]

            updateStatus()
            if(isVideoPaused) pauseVideo()
            if(elm) {
                if(lastElm) lastElm.style.color = ""
                elm.style.color="yellow"
                elm.parentNode.parentNode.parentNode.scrollTop = elm.offsetTop - 50
                lastElm = elm
            }
        }

        window.addEventListener('keydown', (event) => {
            let tagName = event.target.tagName.toLocaleLowerCase()
            if(['textarea', 'input'].includes(tagName)) return

            if(event.keyCode == 191) { // '?' key
                event.preventDefault()

                if(video.paused) {
                    if(lastElm) lastElm.click()
                    playVideo()
                    clearAllSelections()
                }else{
                    let text = lastElm.text.trim()
                    sendIn100('selectionchange', 'document', event, text)
                    pauseVideo()
                }
        	}

            if(event.keyCode == 190) { // '>' key
                event.preventDefault()
                
                pauseVideo()
                clearAllSelections()
                sendIn100('selectionchange', 'document', event, getWholeSentence())
                lastElm.click()
            }

            if(event.keyCode == 188) { // '<' key
                event.preventDefault()
                
				pauseVideo()
                clearAllSelections()
                let elm = previousElementSibling()
                while(true) {
                	if(!elm) {
                		elm = lastElm
                		break
                	}
                	if(elm) {
                		lastElm = elm
                        if(elm.text.endsWith(".") || elm.text.endsWith("!") || elm.text.endsWith("?")) {
                            elm.style.color=""
                            elm = elm.nextElementSibling
                            if(elm) {
                            	lastElm = elm
                            }
                            break
                        }
                	}
                	elm = elm.previousElementSibling
                }
                lastElm.click()
                             
                sendIn100('selectionchange', 'document', event, getWholeSentence())
            }
            if(event.key == 'ArrowLeft') {
                event.preventDefault()
				
                if(!lastElm) return
				pauseVideo()

	            let elm = lastElm.previousElementSibling
	            if(!elm) elm = lastElementSiblingInPreviousParagraph()
	            if(elm) {
	            	if(event.shiftKey) {
                        elm.style.color = "yellow"
	            		sendIn500('selectionchange', 'document', event, getSelectedPhrases())
	            	}else{
                        clearAllSelections()
                        elm.style.color = "yellow"
	                	sendIn500('selectionchange', 'document', event, elm.text.trim())
	            	}
	            	lastElm = elm
	            	lastElm.click()
	        	}
            }
            if(event.key == 'ArrowRight') {
                event.preventDefault()
				
                if(!lastElm) return
				pauseVideo()

                if(lastElm.nextElementSibling) {
                    lastElm = lastElm.nextElementSibling
                }else{
		        	let elm = lastElm.parentElement.nextElementSibling
		            if(elm) lastElm = elm.firstElementChild
                }
            	if(event.shiftKey) {
                    lastElm.style.color = "yellow"
                    sendIn500('selectionchange', 'document', event, getSelectedPhrases())
            	}else{
                    clearAllSelections()
                    lastElm.style.color = "yellow"
                	sendIn500('selectionchange', 'document', event, lastElm.text.trim())
            	}
                lastElm.click()
            }
            if(event.keyCode == 187) { // "+" key
                event.preventDefault()
                
				pauseVideo()
                video.playbackRate += 0.05
                updateStatus()
                event.extra = { playbackRate: video.playbackRate}
                sendIn100('playbackRate', 'video', event)
            }
            if(event.keyCode == 189) { // "-" key
                event.preventDefault()
            
				pauseVideo()
                video.playbackRate -= 0.05
                updateStatus()
                console.log('video.playbackRate', video.playbackRate)
                event.extra = { playbackRate: video.playbackRate}
                sendIn100('playbackRate', 'video', event)
            }
        })
 })()
