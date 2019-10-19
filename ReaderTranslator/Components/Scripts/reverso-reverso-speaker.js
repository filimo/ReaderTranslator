(function() {
    if(!document.querySelector("#entry")) return
    
    function createElementFromHTML(htmlString) {
        var div = document.createElement('div')
        div.innerHTML = htmlString.trim()

        return div.firstChild
    }

    var button = createElementFromHTML('<span class="icon voice" title="Speak a word" data-word="voice"></span>')
    var elm = document.querySelector("#search-links")
    elm.insertBefore(button, elm.children[0])
    button.addEventListener('click', () => {
        const url = "https://voice2.reverso.net/RestPronunciation.svc/v1/output=json/GetVoiceStream/voiceName=Heather22k?inputText="
        const source = document.querySelector("#entry").value
        const inputText = btoa(unescape(encodeURIComponent(source)))
        const sound = new Audio()
        sound.src = `${url}${inputText}`
          sound.play()
    })
})()

