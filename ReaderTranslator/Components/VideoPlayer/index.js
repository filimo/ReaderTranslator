(function() {
  'use strict'

  var toTime = function(time) {
    let date = new Date("1970-01-01")
    let [hours,minutes,seconds] = time.split(':')

    date.setUTCHours(hours)
    date.setUTCMinutes(minutes)
    date.setUTCSeconds(parseInt(seconds))

    return date.valueOf() / 1000
  }

  var parseSRT = function(f) {
    var matches
    var pattern = /(\d+)\n([\d:,]+)\s+-{2}\>\s+([\d:,]+)\n([\s\S]*?(?=\n{2}|$))/gm;
    var toLineObj = function(group) {
      return {
        line: group[1],
        start: toTime(group[2]),
        end: toTime(group[3]),
        content: group[4]
      };
    }

    if (typeof(f) != "string") throw "Sorry, Parser accept string only.";

    var result = [];
    if (f == null)
      return _subtitles;

    f = f.replace(/\r\n|\r|\n/g, '\n')

    while ((matches = pattern.exec(f)) != null) {
      result.push(toLineObj(matches));
    }
    return result;
  }

  let start = async function() {
    let srtData = await $.get('videos/Timeless - 1x01 - Pilot.HDTV.KILLERS.en.srt')
    let srt = parseSRT(srtData)

    let $srt = document.querySelector('#srt')
    let $video = document.querySelector('video')
    let $lastElm

    $srt.innerHTML = srt.map(item=>{
      return `<span start="${item.start}" style="white-space: pre-line; cursor: pointer;">${item.content}</span>`
    }).join('\n')

    Array.from(document.querySelectorAll('[start]')).forEach(item => {
      item.addEventListener('click', function(event) {
        let start = event.currentTarget.getAttribute("start")
        $video.currentTime = parseInt(start)
      })
    })

    $video.ontimeupdate = function() {
        let time = parseInt($video.currentTime)
        let elm = srt.find(item=> {
          return time >= item.start && time <= item.end
        })
        if(elm) {
          let $elm = $srt.querySelector(`[start="${elm.start}"]`)
          if($elm && $lastElm != $elm) {
              if($lastElm) {
                $lastElm.style.color = ""
                $lastElm.removeAttribute("current", true)
              }
              $elm.setAttribute("current", true)
              $elm.style.color="yellow"
              $elm.scrollIntoViewIfNeeded()
              $lastElm = $elm
          }
        }
    }
  }

  start() 
})()
