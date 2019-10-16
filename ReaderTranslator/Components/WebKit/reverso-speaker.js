(function() {
    function createElementFromHTML(htmlString) {
        var div = document.createElement('div')
        div.innerHTML = htmlString.trim()

        return div.firstChild
    }

    var button = createElementFromHTML(' \
    <div class="tlid-input-button input-button header-button" role="tab" tabindex="-1"> \
        <div class="jfk-button-img" style="position: relative;top: 8px;"></div> \
        <div class="text">Sound in Reverso</div> \
    </div>')
    document.querySelector(".tlid-input-button-container").appendChild(button)
    button.addEventListener('click', () => {
        const url = "https://voice2.reverso.net/RestPronunciation.svc/v1/output=json/GetVoiceStream/voiceName=Heather22k?inputText="
        const source = document.querySelector("#source").value
        const inputText = btoa(unescape(encodeURIComponent(source)))
        const sound = new Audio()
        sound.src = `${url}${inputText}`
          sound.play()
    })
})()

