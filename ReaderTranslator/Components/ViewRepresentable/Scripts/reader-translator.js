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

    document.addEventListener('selectionchange', (event) => {
        if(location.hostname == "localhost" && location.pathname.includes('audiobooks')) return

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
	            		sendIn1000('selectionchange', 'document', event, getSelectedPhrases())
	            	}else{
                        clearAllSelections()
                        elm.style.color = "yellow"
	                	sendIn1000('selectionchange', 'document', event, elm.text.trim())
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
                    sendIn1000('selectionchange', 'document', event, getSelectedPhrases())
            	}else{
                    clearAllSelections()
                    lastElm.style.color = "yellow"
                	sendIn1000('selectionchange', 'document', event, lastElm.text.trim())
            	}
                lastElm.click()
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
        if(location.hostname == "localhost" && location.pathname.includes('videos')) { } else { return }

        let $video = document.querySelector('video')
        let $play = document.querySelector('#play')
        let $srt = document.querySelector('#srt')

        function play(event) {
            event.preventDefault()
            let $elm = document.querySelector('[current=true]')
            if($video.paused) {
                document.querySelector('[current=true]').click()
                $video.play()
            }else{
                if($elm) {
                    let text = $elm.textContent.replace('\n', ' ')
                    sendIn100('selectionchange', 'document', event, text)
                    $video.pause()
                }
            }
        }
                     
        $play.addEventListener('click', event => play(event)) 

        $video.ontimeupdate = function() {
            if($video.dataset.stop) {
                delete $video.dataset.stop
                $video.pause()
                let $elm = document.querySelector('[current=true]')
                if($elm) sendIn100('selectionchange', 'document', event, $elm.textContent)
            }
        }  

        window.addEventListener('keydown', event => {
            if(event.keyCode == 191) play(event) // '?' key
            if(event.keyCode == 190) { // '>' key
                let $elm = document.querySelector('[current=true]')
                $elm.nextElementSibling.dataset.stop = true
                play(event)
            }
            if(event.keyCode == 188) { // "<" key
                let $elm = document.querySelector('[current=true]')
                let $prevElm = $elm.previousElementSibling

                if($prevElm) {
                    let text = `${$prevElm.textContent} ${$elm.textContent}`

                    $video.pause()
                    sendIn100('selectionchange', 'document', event, text)
                    $prevElm.click()
                }
            }

            if(event.key == 'ArrowLeft') {
                event.preventDefault() //
                let $elm = document.querySelector('[current=true]')
                let $prevElm = $elm.previousElementSibling

                if($prevElm) {
                    sendIn100('selectionchange', 'document', event, $prevElm.textContent)
                    $video.pause()
                    $prevElm.click()
                }
            }

            if(event.key == 'ArrowRight') {
                event.preventDefault()
                let $elm = document.querySelector('[current=true]')
                let $nextElm = $elm.nextElementSibling

                if($nextElm) {
                    sendIn100('selectionchange', 'document', event, $nextElm.textContent)
                    $video.pause()
                    $nextElm.click()
                }
            }
        })
    })

    //Local audiobook
    document.addEventListener("DOMContentLoaded", (event) => {
        if(location.hostname == "localhost" && location.pathname.includes('audiobooks')) { } else { return }

        var $time = document.createElement('input')
        $time.style.cssText = 'position:fixed;width:100px;top:0;left:0'
        $time.value = "0"
        document.body.appendChild($time)

        let audio = new Audio("../audiobook.m4a")

        audio.oncanplay = function() { 
            audio.currentTime = localStorage.getItem('currentTime') 
        }

        function translateWithoutSpeaking(text) {
            send('selectionchangeWithoutSpeaking', 'document', event, text)
        }

        function init() {
            [...document.querySelectorAll('p')].forEach(item=>{
                let html = (item.textContent.match(/[^\.!\?]+[\.!\?]+/g) || [])
                    .map(item=>`<span class="sentence">${item.trim()}</span>`)
                    .join('\n')
                item.innerHTML = html
            })
            let lastSentence = localStorage.getItem('lastSentence')
            if(lastSentence) {
                let elm = [...document.querySelectorAll('.sentence')]
                            .find(item=>item.textContent==lastSentence)
                
                if(elm) {
                    elm.scrollIntoViewIfNeeded()
                    elm.style.backgroundColor = 'lightgrey'
                }
            }

            var style=document.createElement('style')
            style.type='text/css'
            style.appendChild(document.createTextNode('.sentence:hover { background-color: yellow; background-color: yellow !important; }'))
            document.getElementsByTagName('head')[0].appendChild(style)

            document.addEventListener('dblclick', event => {
                let elm = event.target
                if(elm.className == 'sentence') {
                    elm.removeAttribute('time')
                }
            })

            document.addEventListener('click', event => {
                let selectedText = getSelection().toString()

                if(selectedText) {
                    translateWithoutSpeaking(selectedText)
                    return
                }

                let elm = event.target
                if(elm.className == 'sentence') {
                    let time = elm.getAttribute('time')
                    if(time) {
                        audio.currentTime = time
                    }else{
                        audio.pause()
                        localStorage.setItem('lastSentence', elm.textContent)
                        elm.style.backgroundColor="lightgrey"
                        elm.setAttribute('time', audio.currentTime)
                        translateWithoutSpeaking(elm.textContent)
                        return
                    }

                    if(audio.paused) {
                        send('play', 'video', event, '')
                        audio.play()
                    }else{
                        audio.pause()
                        translateWithoutSpeaking(elm.textContent)
                    }
                }
            })              
        }

        function tapped() {
//            audio.play()
//            document.body.removeEventListener("click", tapped, false)
        }

//        document.body.addEventListener('click', tapped, false)

        audio.ontimeupdate = function() {
            localStorage.setItem('currentTime', audio.currentTime)
            $time.value = Math.round(audio.currentTime * 10) / 10
        }
        $time.addEventListener('change', event => {
            audio.currentTime = event.currentTarget.value
        })

        window.addEventListener('keydown', event => {
            function play(event) {
                event.preventDefault()
                if(audio.paused) {
                    send('pause', 'video', event, '')
                    audio.play()
                }else{
                    audio.pause()
                }
            }           
            
            if(event.keyCode == 191) { // `?` key
                play(event)
            }
            if(event.key == 'ArrowLeft') { audio.currentTime -= 1 }
            if(event.key == 'ArrowRight') { audio.currentTime += 1 }
            if(event.keyCode == 222) { // `'` key
            }
            if(event.keyCode == 188) { // `<`` key
                audio.play()
            }
            if(event.keyCode == 68) { // `d` key

            }            
        })

        init()
    })    
 })()
