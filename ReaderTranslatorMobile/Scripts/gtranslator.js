(function() {
//     const css = " textarea, .tlid-translation { font-size: 18px!important; } "
     
//     let style = document.createElement('style')
//     style.innerHTML = css
//     document.head.appendChild(style)

     let mode = localStorage.getItem('readerTranslatorMode') || 'full'
     readerTranslatorMode(mode)
})()

function readerTranslatorMode(mode) {
	localStorage.setItem('readerTranslatorMode', mode)
//	let elm = document.querySelector('body')
//	elm.className = elm.className.replace('reader-mini', '')

	if(mode=='mini') { elm.className += " reader-mini" }
    
    document.querySelector(`[name="viewport"]`).setAttribute('content', 'width=device-width,minimum-scale=0.8,maximum-scale=0.8')
}
