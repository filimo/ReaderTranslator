(function() {
    document.body.style.zoom = 0.8
    
    setInterval(() => {
        let onetrust = document.querySelector('#onetrust-consent-sdk')
        if (onetrust) onetrust.remove()
        
        let topSlot = document.querySelector('.topslot_container')
        if (topSlot) topSlot.remove()
        
        let stickyslot = document.querySelector('#stickyslot_container')
        if (stickyslot) stickyslot.remove()

    }, 500)
})()
