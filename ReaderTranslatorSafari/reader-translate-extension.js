(function() {
    function send(name, source, e) {
        var txt = document.getSelection().toString()
        if(txt.trim()) {
            let event = {
                time: Date(), // to prevent removing duplicate events
                name: name,
                source: source,
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
            safari.extension.dispatchMessage(JSON.stringify(event))
        }
    }

    document.addEventListener("DOMContentLoaded", (event) => {
        //disabled: sometimes this event occurs after press keys
//        send({name: 'DOMContentLoaded', source: 'document'})
    })

    document.addEventListener('selectionchange', (event) => {
        var txt = document.getSelection().toString()
        if(txt.trim()) {
            send('selectionchange', 'document', event)
        }
    })

    window.addEventListener('keydown', (event) => {
        if(event.keyCode >= 65 && event.keyCode <= 90) {
            if(['text', 'textarea'].indexOf(event.srcElement.type) != -1) {
                if(!(event.ctrlKey || event.altKey)) return
            }
            send('keydown', 'window', event)
        }else{
            if(event.altKey && event.metaKey) {
                send('keydown', 'window', event)
            }
        }
    })
 })()

