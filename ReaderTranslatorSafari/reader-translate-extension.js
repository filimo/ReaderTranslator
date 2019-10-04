(function() {
    function send(event) {
        safari.extension.dispatchMessage(JSON.stringify(event))
    }

    document.addEventListener("DOMContentLoaded", (event) => {
        send({name: 'DOMContentLoaded', source: 'document'})
    })

    document.addEventListener('selectionchange', (event) => {
        var txt = document.getSelection().toString()
        send({name: 'selectionchange', source: 'document', extra: { selectedText: txt } })
    })

    window.addEventListener('keydown', (e) => {
        if (e.keyCode >= 65 && e.keyCode <= 90) {
            var txt = document.getSelection().toString()
            let event = {
                time: Date(), // to prevent removing duplicate events
                name: 'keydown',
                source: 'window',
                extra: {
                    ctrlKey: e.ctrlKey,
                    altKey: e.altKey,
                    metaKey: e.metaKey, //⌘ Command
                    shiftKey: e.shiftKey,
                    which: e.which,
                    keyCode: e.keyCode,
                    selectedText: txt,
                }
            }
            send(event)
        }
    })
 })()

