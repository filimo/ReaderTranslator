document.addEventListener("DOMContentLoaded", function(event) {
});

document.onselectionchange = function() {
    var txt = document.getSelection().toString()
    
    safari.extension.dispatchMessage(txt)
}
