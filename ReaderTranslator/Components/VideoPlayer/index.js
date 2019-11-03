(function() {
  'use strict'
  function start() {
    let $srt = document.querySelector('#srt')
    let $video = document.querySelector('video')
    let $lastElm

    $srt.innerHTML = srt.map(item=>{
      return `<span start="${item.start}" style="white-space: pre-line; cursor: pointer;">${item.content}</span>`
    }).join('&nbsp;')

    Array.from(document.querySelectorAll('[start]')).forEach(item => {
      item.addEventListener('click', function(event) {
        let start = event.currentTarget.getAttribute("start")
        $video.currentTime = parseInt(start)/1000 - 1
      })
    })

    $video.ontimeupdate = function() {
        let time = parseInt($video.currentTime*1000)
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

  let srt = [
  {
    "content": "\u2010 HENRY: Where is he?\n\u2010 ALAN: Who?", 
    "end": 5796, 
    "index": 1, 
    "start": 4046
  }, 
  {
    "content": "\u2010 My father.\n\u2010 They moved him", 
    "end": 7633, 
    "index": 2, 
    "start": 5797
  }, 
  {
    "content": "to a yard up in Bangor\nby the airport.", 
    "end": 10343, 
    "index": 3, 
    "start": 7633
  }, 
  {
    "content": "HENRY: Did she even know\nwhat she was signing for?", 
    "end": 12845, 
    "index": 4, 
    "start": 10343
  }, 
  {
    "content": "What else you been\nsigning for her, Alan?", 
    "end": 14848, 
    "index": 5, 
    "start": 12846
  }, 
  {
    "content": "Oh! The sheets!", 
    "end": 17726, 
    "index": 6, 
    "start": 16183
  }, 
  {
    "content": "Your mom's been leaving food out\nfor the neighborhood mutt.", 
    "end": 23065, 
    "index": 7, 
    "start": 19811
  }, 
  {
    "content": "We buried it New Year's Day.\nTruck.", 
    "end": 26068, 
    "index": 8, 
    "start": 23065
  }, 
  {
    "content": "RUTH:\n<i>It's like I open the book</i>", 
    "end": 27903, 
    "index": 9, 
    "start": 26068
  }, 
  {
    "content": "<i>and all the pages,\nsomeone tore them out</i>", 
    "end": 30405, 
    "index": 10, 
    "start": 27903
  }, 
  {
    "content": "\u2010 Mom!\n\u2010 <i>and rearranged them.</i>", 
    "end": 33283, 
    "index": 11, 
    "start": 30405
  }, 
  {
    "content": "( splash )", 
    "end": 35160, 
    "index": 12, 
    "start": 33283
  }, 
  {
    "content": "ALAN:\n<i>I bought her a ring in '91.</i>", 
    "end": 37829, 
    "index": 13, 
    "start": 35160
  }, 
  {
    "content": "<i>Eventually I moved back.\nThen I get a phone call.</i>", 
    "end": 40998, 
    "index": 14, 
    "start": 37829
  }, 
  {
    "content": "Somebody heard gunfire\nup at your mom's place.", 
    "end": 44001, 
    "index": 15, 
    "start": 40998
  }, 
  {
    "content": "\u2010 Gunfire?\n\u2010 Your mother came to the door,", 
    "end": 46421, 
    "index": 16, 
    "start": 44002
  }, 
  {
    "content": "threw her arms around me,", 
    "end": 48632, 
    "index": 17, 
    "start": 46421
  }, 
  {
    "content": "begged me, \"Don't leave!\"", 
    "end": 51051, 
    "index": 18, 
    "start": 48632
  }, 
  {
    "content": "If I tell you something,\ncan you keep your mouth shut?", 
    "end": 54972, 
    "index": 19, 
    "start": 51051
  }, 
  {
    "content": "RUTH: <i>Life used to go\nin one direction,</i>", 
    "end": 58684, 
    "index": 20, 
    "start": 54972
  }, 
  {
    "content": "\u2010 <i>but somehow I got off it.</i>\n\u2010 Ruthie?", 
    "end": 60518, 
    "index": 21, 
    "start": 58684
  }, 
  {
    "content": "<i>The neurologist said,</i>", 
    "end": 62478, 
    "index": 22, 
    "start": 60518
  }, 
  {
    "content": "<i>\"Find a coping mechanism,\"\nand I have.</i>", 
    "end": 65524, 
    "index": 23, 
    "start": 62479
  }, 
  {
    "content": "One for every room in the house.", 
    "end": 67568, 
    "index": 24, 
    "start": 65524
  }, 
  {
    "content": "Damn it!", 
    "end": 70320, 
    "index": 25, 
    "start": 68860
  }, 
  {
    "content": "You're back.", 
    "end": 74533, 
    "index": 26, 
    "start": 72739
  }, 
  {
    "content": "\u2010 ( record skipping )\n\u2010 ALAN: Ruth!", 
    "end": 76868, 
    "index": 27, 
    "start": 74533
  }, 
  {
    "content": "\u2010 ( fire alarm beeping )\n\u2010 ( skillet sizzling )", 
    "end": 80289, 
    "index": 28, 
    "start": 76868
  }, 
  {
    "content": "Ruthie?!", 
    "end": 82416, 
    "index": 29, 
    "start": 80289
  }, 
  {
    "content": "<i>Ruthie!</i>", 
    "end": 83959, 
    "index": 30, 
    "start": 82416
  }, 
  {
    "content": "( Ruth panting )", 
    "end": 97472, 
    "index": 31, 
    "start": 94720
  }, 
  {
    "content": "( Ruth muttering )", 
    "end": 102185, 
    "index": 32, 
    "start": 100142
  }, 
  {
    "content": "( whimpering )", 
    "end": 118534, 
    "index": 33, 
    "start": 117034
  }, 
  {
    "content": "( clatter )", 
    "end": 131298, 
    "index": 34, 
    "start": 129171
  }, 
  {
    "content": "ALAN: Lady on the internet\nsays they were made by Vikings,", 
    "end": 139348, 
    "index": 35, 
    "start": 136136
  }, 
  {
    "content": "\u2010 so I figured...\n\u2010 RUTH: Oh! The Lewis chessmen.", 
    "end": 142351, 
    "index": 36, 
    "start": 139348
  }, 
  {
    "content": "You know, the originals,\nthey were carved", 
    "end": 145020, 
    "index": 37, 
    "start": 142351
  }, 
  {
    "content": "out of walrus ivory\nby the wife of a priest\u2010\u2010", 
    "end": 148023, 
    "index": 38, 
    "start": 145020
  }, 
  {
    "content": "Margaret the Adroit.", 
    "end": 149483, 
    "index": 39, 
    "start": 148023
  }, 
  {
    "content": "ALAN: You are still\nthe smartest person I know.", 
    "end": 152611, 
    "index": 40, 
    "start": 149483
  }, 
  {
    "content": "Smart enough to know\nwhat you're up to.", 
    "end": 154988, 
    "index": 41, 
    "start": 152611
  }, 
  {
    "content": "Come on. No, come on,\nthis way.", 
    "end": 157699, 
    "index": 42, 
    "start": 154988
  }, 
  {
    "content": "What else did the internet\nteach you?", 
    "end": 162245, 
    "index": 43, 
    "start": 159034
  }, 
  {
    "content": "That chess is good\nfor the demented brain?", 
    "end": 164873, 
    "index": 44, 
    "start": 162245
  }, 
  {
    "content": "( holiday music playing\non stereo )", 
    "end": 167417, 
    "index": 45, 
    "start": 164873
  }, 
  {
    "content": "We got any champagne\naround this house?", 
    "end": 170170, 
    "index": 46, 
    "start": 167417
  }, 
  {
    "content": "RADIO: <i>Here's one more\nlast\u2010minute resolution.</i>", 
    "end": 171963, 
    "index": 47, 
    "start": 170170
  }, 
  {
    "content": "<i>When you're on the road today,</i>", 
    "end": 173840, 
    "index": 48, 
    "start": 171963
  }, 
  {
    "content": "<i>steer clear of the turnpike\nfrom Portland to Augusta.</i>", 
    "end": 176718, 
    "index": 49, 
    "start": 173840
  }, 
  {
    "content": "Where did you run off to?", 
    "end": 179221, 
    "index": 50, 
    "start": 176718
  }, 
  {
    "content": "I splurged\u2010\u2010\n$30 Japanese steaks.", 
    "end": 182557, 
    "index": 51, 
    "start": 179221
  }, 
  {
    "content": "\u2010 What is it?\n\u2010 Aw, nothin'.", 
    "end": 186061, 
    "index": 52, 
    "start": 184017
  }, 
  {
    "content": "Be back in two shakes.\nSet up those chessmen.", 
    "end": 188397, 
    "index": 53, 
    "start": 186061
  }, 
  {
    "content": "I'll let you slaughter me\nafter dinner.", 
    "end": 191024, 
    "index": 54, 
    "start": 188397
  }, 
  {
    "content": "( dog whimpers )", 
    "end": 195737, 
    "index": 55, 
    "start": 194277
  }, 
  {
    "content": "( dog groaning )", 
    "end": 208208, 
    "index": 56, 
    "start": 204621
  }, 
  {
    "content": "Ruthie, wait in the house.", 
    "end": 211503, 
    "index": 57, 
    "start": 208208
  }, 
  {
    "content": "Did you call...\nthe veterin\u2010\u2010", 
    "end": 215715, 
    "index": 58, 
    "start": 213088
  }, 
  {
    "content": "The clinic?", 
    "end": 218718, 
    "index": 59, 
    "start": 217259
  }, 
  {
    "content": "On South Reserve?", 
    "end": 221388, 
    "index": 60, 
    "start": 218718
  }, 
  {
    "content": "He doesn't need a vet.", 
    "end": 223432, 
    "index": 61, 
    "start": 221388
  }, 
  {
    "content": "SOB came outta nowhere.", 
    "end": 225434, 
    "index": 62, 
    "start": 223432
  }, 
  {
    "content": "She.", 
    "end": 232357, 
    "index": 63, 
    "start": 230147
  }, 
  {
    "content": "MAN: Ma'am?", 
    "end": 234276, 
    "index": 64, 
    "start": 232357
  }, 
  {
    "content": "She's not a son of a bitch.\nShe's a bitch.", 
    "end": 236987, 
    "index": 65, 
    "start": 234276
  }, 
  {
    "content": "( dog whimpers )", 
    "end": 242325, 
    "index": 66, 
    "start": 240574
  }, 
  {
    "content": "( sighs )", 
    "end": 252127, 
    "index": 67, 
    "start": 250876
  }, 
  {
    "content": "( Alan clears throat )", 
    "end": 260552, 
    "index": 68, 
    "start": 259468
  }, 
  {
    "content": "We goin' somewhere?", 
    "end": 262721, 
    "index": 69, 
    "start": 260552
  }, 
  {
    "content": "It's for Puck.", 
    "end": 266016, 
    "index": 70, 
    "start": 264055
  }, 
  {
    "content": "Puck was your boy's dog.", 
    "end": 272898, 
    "index": 71, 
    "start": 269770
  }, 
  {
    "content": "Used to leave dead squirrels\non your pillow", 
    "end": 275150, 
    "index": 72, 
    "start": 272898
  }, 
  {
    "content": "like hotel mints, remember?", 
    "end": 277903, 
    "index": 73, 
    "start": 275150
  }, 
  {
    "content": "That dog out there is...\njust a neighborhood stray.", 
    "end": 281739, 
    "index": 74, 
    "start": 277903
  }, 
  {
    "content": "I know that.", 
    "end": 286328, 
    "index": 75, 
    "start": 284326
  }, 
  {
    "content": "Did I ever tell you about...\nwhat happened to Puck?", 
    "end": 292167, 
    "index": 76, 
    "start": 288330
  }, 
  {
    "content": "I came home one day, and...", 
    "end": 299925, 
    "index": 77, 
    "start": 295212
  }, 
  {
    "content": "she was just gone.", 
    "end": 302093, 
    "index": 78, 
    "start": 299925
  }, 
  {
    "content": "Matthew said she...\nshe must have run off.", 
    "end": 309601, 
    "index": 79, 
    "start": 305472
  }, 
  {
    "content": "But I found a box of poison\nin the trash.", 
    "end": 313313, 
    "index": 80, 
    "start": 309601
  }, 
  {
    "content": "( crying )\nYou have no idea.", 
    "end": 315148, 
    "index": 81, 
    "start": 313313
  }, 
  {
    "content": "\u2010 What?\n\u2010 What he was capable of.", 
    "end": 318527, 
    "index": 82, 
    "start": 315148
  }, 
  {
    "content": "I used to see turkey vultures", 
    "end": 323490, 
    "index": 83, 
    "start": 320111
  }, 
  {
    "content": "wheeling around the sky\nout back...over the woods,", 
    "end": 327536, 
    "index": 84, 
    "start": 323490
  }, 
  {
    "content": "but I was too chickenshit\nto go look.", 
    "end": 330413, 
    "index": 85, 
    "start": 327536
  }, 
  {
    "content": "The thought of her\nbeing picked apart,", 
    "end": 335836, 
    "index": 86, 
    "start": 333458
  }, 
  {
    "content": "no one to bury her.", 
    "end": 337420, 
    "index": 87, 
    "start": 335836
  }, 
  {
    "content": "And you think buryin' one dog\npays the debt on the other.", 
    "end": 344094, 
    "index": 88, 
    "start": 340257
  }, 
  {
    "content": "( dog whimpering )", 
    "end": 374875, 
    "index": 89, 
    "start": 372289
  }, 
  {
    "content": "( dog barks )", 
    "end": 376293, 
    "index": 90, 
    "start": 374875
  }, 
  {
    "content": "Puck.", 
    "end": 381256, 
    "index": 91, 
    "start": 379504
  }, 
  {
    "content": "( barks )", 
    "end": 387345, 
    "index": 92, 
    "start": 385760
  }, 
  {
    "content": "( barks )", 
    "end": 390432, 
    "index": 93, 
    "start": 389389
  }, 
  {
    "content": "HENRY: They can't do that\nwithout our permission.", 
    "end": 406239, 
    "index": 94, 
    "start": 404070
  }, 
  {
    "content": "ALAN: Your mother gave it.", 
    "end": 408158, 
    "index": 95, 
    "start": 406239
  }, 
  {
    "content": "And nobody thought to\npick up the phone and call me?", 
    "end": 411077, 
    "index": 96, 
    "start": 408158
  }, 
  {
    "content": "Did she even know\nwhat she was signing for?", 
    "end": 413413, 
    "index": 97, 
    "start": 411077
  }, 
  {
    "content": "You signed for her.", 
    "end": 416374, 
    "index": 98, 
    "start": 414706
  }, 
  {
    "content": "ALAN: I deposited the distress\nsettlement for her, too.", 
    "end": 419502, 
    "index": 99, 
    "start": 416374
  }, 
  {
    "content": "What else you been\nsigning for her, Alan?", 
    "end": 425884, 
    "index": 100, 
    "start": 423506
  }, 
  {
    "content": "Oh! The sheets!", 
    "end": 437520, 
    "index": 101, 
    "start": 435644
  }, 
  {
    "content": "<i>( theme music playing )</i>", 
    "end": 459959, 
    "index": 102, 
    "start": 456498
  }, 
  {
    "content": "DOCTOR: OK, dear.\nAlmost done.", 
    "end": 491324, 
    "index": 103, 
    "start": 488113
  }, 
  {
    "content": "A few minutes ago\nI read a list of words", 
    "end": 495036, 
    "index": 104, 
    "start": 492951
  }, 
  {
    "content": "and asked you to repeat them.", 
    "end": 496371, 
    "index": 105, 
    "start": 495036
  }, 
  {
    "content": "Can you repeat them\nback to me now?", 
    "end": 498957, 
    "index": 106, 
    "start": 496371
  }, 
  {
    "content": "Any order you like.", 
    "end": 500834, 
    "index": 107, 
    "start": 498957
  }, 
  {
    "content": "RUTH:\nSomeone sent you flowers.", 
    "end": 507882, 
    "index": 108, 
    "start": 505171
  }, 
  {
    "content": "The mouse ran up the\u2010\u2010", 
    "end": 511720, 
    "index": 109, 
    "start": 508883
  }, 
  {
    "content": "\u2010 No hints.\n\u2010 Just give her one", 
    "end": 513888, 
    "index": 110, 
    "start": 511720
  }, 
  {
    "content": "and it'll all come back.", 
    "end": 515432, 
    "index": 111, 
    "start": 513888
  }, 
  {
    "content": "DOCTOR: Please, sir.", 
    "end": 516975, 
    "index": 112, 
    "start": 515432
  }, 
  {
    "content": "If you wouldn't mind\njust waiting outside?", 
    "end": 518852, 
    "index": 113, 
    "start": 516975
  }, 
  {
    "content": "ALAN:\nYeah, I would mind. \"Dear\"?", 
    "end": 520895, 
    "index": 114, 
    "start": 518852
  }, 
  {
    "content": "Do you know how fucking\ncondescending that sounds?", 
    "end": 523940, 
    "index": 115, 
    "start": 520895
  }, 
  {
    "content": "She has a brain\nthe size of Portland.", 
    "end": 526484, 
    "index": 116, 
    "start": 523940
  }, 
  {
    "content": "( Alan chuckles )", 
    "end": 527569, 
    "index": 117, 
    "start": 526484
  }, 
  {
    "content": "But it's sick, Alan.", 
    "end": 532449, 
    "index": 118, 
    "start": 530071
  }, 
  {
    "content": "Alzheimer's.", 
    "end": 533783, 
    "index": 119, 
    "start": 532449
  }, 
  {
    "content": "Why won't anyone use that\u2010\u2010\nthat word?", 
    "end": 538747, 
    "index": 120, 
    "start": 535702
  }, 
  {
    "content": "DOCTOR: There's no diagnostic\ntest for Alzheimer's.", 
    "end": 541958, 
    "index": 121, 
    "start": 538747
  }, 
  {
    "content": "Confirmation's made postmortem", 
    "end": 544002, 
    "index": 122, 
    "start": 541958
  }, 
  {
    "content": "by examining the brain\nfor plaques and other hallmarks.", 
    "end": 547088, 
    "index": 123, 
    "start": 544002
  }, 
  {
    "content": "Postmortem? Let's get\nthe fuck out of here.", 
    "end": 550050, 
    "index": 124, 
    "start": 547088
  }, 
  {
    "content": "We're going to Darden.", 
    "end": 551676, 
    "index": 125, 
    "start": 550050
  }, 
  {
    "content": "DOCTOR: Doesn't matter\nwhat we call it.", 
    "end": 553344, 
    "index": 126, 
    "start": 551676
  }, 
  {
    "content": "These things\nmove in one direction.", 
    "end": 555263, 
    "index": 127, 
    "start": 553344
  }, 
  {
    "content": "Higher\u2010order functions\nbecome more challenging.", 
    "end": 558933, 
    "index": 128, 
    "start": 555263
  }, 
  {
    "content": "Your ability to exercise\nreason and judgment...", 
    "end": 562103, 
    "index": 129, 
    "start": 558933
  }, 
  {
    "content": "finances, drive a car...\nplanning and problem\u2010solving...", 
    "end": 566274, 
    "index": 130, 
    "start": 562103
  }, 
  {
    "content": "confusion with time and space...", 
    "end": 568776, 
    "index": 131, 
    "start": 566274
  }, 
  {
    "content": "<i>Confusion</i>\nwith time and space.", 
    "end": 571488, 
    "index": 132, 
    "start": 568777
  }, 
  {
    "content": "She slips up.", 
    "end": 575450, 
    "index": 133, 
    "start": 573448
  }, 
  {
    "content": "And reading and...\nthe face of my own son.", 
    "end": 579579, 
    "index": 134, 
    "start": 575450
  }, 
  {
    "content": "DOCTOR: We can medicate\nthe anxiety", 
    "end": 584542, 
    "index": 135, 
    "start": 581956
  }, 
  {
    "content": "and help you develop systems,\ncoping mechanisms.", 
    "end": 588505, 
    "index": 136, 
    "start": 584542
  }, 
  {
    "content": "But given the accident,", 
    "end": 591007, 
    "index": 137, 
    "start": 588505
  }, 
  {
    "content": "I think it's time to consider\nother living arrangements.", 
    "end": 594469, 
    "index": 138, 
    "start": 591007
  }, 
  {
    "content": "ALAN:\n<i>Listen...</i>", 
    "end": 602560, 
    "index": 139, 
    "start": 601267
  }, 
  {
    "content": "that brain doctor,", 
    "end": 605105, 
    "index": 140, 
    "start": 602560
  }, 
  {
    "content": "I don't care how many degrees\nshe's got on her fuckin' wall\u2010\u2010", 
    "end": 609109, 
    "index": 141, 
    "start": 605105
  }, 
  {
    "content": "Don't make me\nwash your mouth out.", 
    "end": 612278, 
    "index": 142, 
    "start": 609109
  }, 
  {
    "content": "I knocked on that door\nafter 14 years.", 
    "end": 615573, 
    "index": 143, 
    "start": 612278
  }, 
  {
    "content": "You remember\nwhat you said?", 
    "end": 617075, 
    "index": 144, 
    "start": 615573
  }, 
  {
    "content": "\"Don't leave.\"", 
    "end": 621371, 
    "index": 145, 
    "start": 620120
  }, 
  {
    "content": "See? It's all still up there.", 
    "end": 625083, 
    "index": 146, 
    "start": 622497
  }, 
  {
    "content": "Listen, after I get you settled,", 
    "end": 629879, 
    "index": 147, 
    "start": 627669
  }, 
  {
    "content": "I got some business\nto take care of,", 
    "end": 631631, 
    "index": 148, 
    "start": 629879
  }, 
  {
    "content": "and when I come back,\nI'm not going anywhere,", 
    "end": 634968, 
    "index": 149, 
    "start": 631631
  }, 
  {
    "content": "and neither are you.", 
    "end": 637220, 
    "index": 150, 
    "start": 634968
  }, 
  {
    "content": "We're gonna fix you up\nas good as new.", 
    "end": 640306, 
    "index": 151, 
    "start": 637220
  }, 
  {
    "content": "Yeah, I just...", 
    "end": 642308, 
    "index": 152, 
    "start": 640306
  }, 
  {
    "content": "I just need a system,\nthat's all.", 
    "end": 645186, 
    "index": 153, 
    "start": 642308
  }, 
  {
    "content": "YOUNG RUTH: \"They will not\nfind their way back home,", 
    "end": 714464, 
    "index": 154, 
    "start": 711878
  }, 
  {
    "content": "and we will be rid of them.", 
    "end": 716090, 
    "index": 155, 
    "start": 714464
  }, 
  {
    "content": "'I refuse,' said the man.", 
    "end": 718760, 
    "index": 156, 
    "start": 716090
  }, 
  {
    "content": "'How can I bring myself", 
    "end": 720303, 
    "index": 157, 
    "start": 718760
  }, 
  {
    "content": "to abandon my own children\nalone in the woods?", 
    "end": 723056, 
    "index": 158, 
    "start": 720303
  }, 
  {
    "content": "Wild animals would tear them\nto pieces.'\"", 
    "end": 726226, 
    "index": 159, 
    "start": 723056
  }, 
  {
    "content": "\"'Oh, you fool,'\nsaid the wife.", 
    "end": 733732, 
    "index": 160, 
    "start": 731021
  }, 
  {
    "content": "'Then all four of us\nwill starve.'", 
    "end": 736236, 
    "index": 161, 
    "start": 733733
  }, 
  {
    "content": "The clever boy filled his jacket\npockets with pebbles,", 
    "end": 739696, 
    "index": 162, 
    "start": 736236
  }, 
  {
    "content": "as many as he could fit.", 
    "end": 742074, 
    "index": 163, 
    "start": 739696
  }, 
  {
    "content": "He would use the stones to lay\na trail through the forest...\"", 
    "end": 745245, 
    "index": 164, 
    "start": 742075
  }, 
  {
    "content": "Older then he was when?", 
    "end": 747372, 
    "index": 165, 
    "start": 745245
  }, 
  {
    "content": "Ever.", 
    "end": 748456, 
    "index": 166, 
    "start": 747372
  }, 
  {
    "content": "Is that why you're here?", 
    "end": 755254, 
    "index": 167, 
    "start": 752043
  }, 
  {
    "content": "I was... I was thinkin'\nabout when you turned seven.", 
    "end": 759133, 
    "index": 168, 
    "start": 755255
  }, 
  {
    "content": "Made a big batch\nof that buttercream frosting.", 
    "end": 762595, 
    "index": 169, 
    "start": 759133
  }, 
  {
    "content": "That was before we knew\nabout your lactose thing.", 
    "end": 765640, 
    "index": 170, 
    "start": 762595
  }, 
  {
    "content": "I never seen a cake disappear\nand reappear that fast.", 
    "end": 768685, 
    "index": 171, 
    "start": 765640
  }, 
  {
    "content": "You probably\ndon't remember that.", 
    "end": 772563, 
    "index": 172, 
    "start": 770436
  }, 
  {
    "content": "ALAN:\nMagic 101.", 
    "end": 789414, 
    "index": 173, 
    "start": 787120
  }, 
  {
    "content": "This is called...\nthe French Drop.", 
    "end": 794085, 
    "index": 174, 
    "start": 789414
  }, 
  {
    "content": "This is called palming.", 
    "end": 800591, 
    "index": 175, 
    "start": 797422
  }, 
  {
    "content": "Either holding it\nwith the creases of your palm,", 
    "end": 804637, 
    "index": 176, 
    "start": 800591
  }, 
  {
    "content": "or what I prefer to do\nis to do a thumb palm.", 
    "end": 807432, 
    "index": 177, 
    "start": 804637
  }, 
  {
    "content": "RUTH: Why do all magic tricks\nsound pornographic?", 
    "end": 810643, 
    "index": 178, 
    "start": 807432
  }, 
  {
    "content": "\u2010 ( Ruth laughs )\n\u2010 I don't know,", 
    "end": 812145, 
    "index": 179, 
    "start": 810643
  }, 
  {
    "content": "'cause they're\ninvented by virgins.", 
    "end": 813813, 
    "index": 180, 
    "start": 812145
  }, 
  {
    "content": "Here, you try.\nGive it a shot. Go ahead.", 
    "end": 816190, 
    "index": 181, 
    "start": 813813
  }, 
  {
    "content": "Stick your\u2010\u2010that's it,\nyou sell it with your thumb,", 
    "end": 821446, 
    "index": 182, 
    "start": 818735
  }, 
  {
    "content": "then just drop it down\ngently there...", 
    "end": 824157, 
    "index": 183, 
    "start": 821446
  }, 
  {
    "content": "Great. Great. Yeah!", 
    "end": 829077, 
    "index": 184, 
    "start": 826450
  }, 
  {
    "content": "You got it.", 
    "end": 830580, 
    "index": 185, 
    "start": 829078
  }, 
  {
    "content": "You got the French Drop.", 
    "end": 832957, 
    "index": 186, 
    "start": 830580
  }, 
  {
    "content": "Now all you gotta work on\nis...palming!", 
    "end": 835501, 
    "index": 187, 
    "start": 832957
  }, 
  {
    "content": "( laughs )\nNo palming!", 
    "end": 838003, 
    "index": 188, 
    "start": 835501
  }, 
  {
    "content": "( knock on door )", 
    "end": 841215, 
    "index": 189, 
    "start": 840048
  }, 
  {
    "content": "Mom?", 
    "end": 843676, 
    "index": 190, 
    "start": 842592
  }, 
  {
    "content": "Picked up a hitchhiker.", 
    "end": 848514, 
    "index": 191, 
    "start": 846596
  }, 
  {
    "content": "Oh! Come over here\nand give me a hug.", 
    "end": 851976, 
    "index": 192, 
    "start": 848514
  }, 
  {
    "content": "Oh, look at you.", 
    "end": 853895, 
    "index": 193, 
    "start": 851976
  }, 
  {
    "content": "Look at you.", 
    "end": 856731, 
    "index": 194, 
    "start": 855354
  }, 
  {
    "content": "How old is this turkey?", 
    "end": 862987, 
    "index": 195, 
    "start": 859776
  }, 
  {
    "content": "So they dug him up just to stick\nhim back in the ground again?", 
    "end": 866783, 
    "index": 196, 
    "start": 862987
  }, 
  {
    "content": "Is that a thing up here?", 
    "end": 868367, 
    "index": 197, 
    "start": 866783
  }, 
  {
    "content": "Ask your father.", 
    "end": 870661, 
    "index": 198, 
    "start": 868367
  }, 
  {
    "content": "\"Behold,\nI will tell you a mystery.", 
    "end": 876042, 
    "index": 199, 
    "start": 873498
  }, 
  {
    "content": "Not all will sleep,\nbut all will be changed,", 
    "end": 878503, 
    "index": 200, 
    "start": 876042
  }, 
  {
    "content": "in a moment,\nin the twinkling of an eye...", 
    "end": 882465, 
    "index": 201, 
    "start": 878503
  }, 
  {
    "content": "MATTHEW:\n...the last trumpet,", 
    "end": 884217, 
    "index": 202, 
    "start": 882465
  }, 
  {
    "content": "for the trumpet will sound\nand the dead will be raised,", 
    "end": 887678, 
    "index": 203, 
    "start": 884217
  }, 
  {
    "content": "imperishable,\nand we will all be changed.", 
    "end": 891641, 
    "index": 204, 
    "start": 887678
  }, 
  {
    "content": "For this perishable must put on\nthe imperishable,", 
    "end": 894477, 
    "index": 205, 
    "start": 891641
  }, 
  {
    "content": "and this mortal\nmust put on immortality.", 
    "end": 898606, 
    "index": 206, 
    "start": 894477
  }, 
  {
    "content": "But when this perishable\nput on the imperishable,", 
    "end": 900942, 
    "index": 207, 
    "start": 898606
  }, 
  {
    "content": "and this mortal\nput on immortality,", 
    "end": 904695, 
    "index": 208, 
    "start": 900942
  }, 
  {
    "content": "then...", 
    "end": 905947, 
    "index": 209, 
    "start": 904695
  }, 
  {
    "content": "...will come about\nthe saying that is written:", 
    "end": 912745, 
    "index": 210, 
    "start": 908574
  }, 
  {
    "content": "\"Death...", 
    "end": 915748, 
    "index": 211, 
    "start": 912745
  }, 
  {
    "content": "is swallowed up\nin victory.\"", 
    "end": 917917, 
    "index": 212, 
    "start": 915748
  }, 
  {
    "content": "Hymn 114.\n\"O God Our Help in Ages Past.\"", 
    "end": 935434, 
    "index": 213, 
    "start": 931514
  }, 
  {
    "content": "( piano plays intro to hymn )", 
    "end": 938896, 
    "index": 214, 
    "start": 935434
  }, 
  {
    "content": "CONGREGATION: \u266a O God\nour help in ages past \u266a", 
    "end": 943109, 
    "index": 215, 
    "start": 938896
  }, 
  {
    "content": "\u266a Our hope for years to come \u266a", 
    "end": 947822, 
    "index": 216, 
    "start": 943109
  }, 
  {
    "content": "\u266a Our shelter...", 
    "end": 949740, 
    "index": 217, 
    "start": 947822
  }, 
  {
    "content": "WENDELL:\n\"Swallowed up in victory.\"", 
    "end": 952201, 
    "index": 218, 
    "start": 949740
  }, 
  {
    "content": "Hardcore.", 
    "end": 954370, 
    "index": 219, 
    "start": 952201
  }, 
  {
    "content": "HENRY: Mom, I have got\nlunch under control.", 
    "end": 958583, 
    "index": 220, 
    "start": 955913
  }, 
  {
    "content": "You should\nstay off your feet.", 
    "end": 960418, 
    "index": 221, 
    "start": 958583
  }, 
  {
    "content": "I thought you were\nthe only one there.", 
    "end": 962336, 
    "index": 222, 
    "start": 960418
  }, 
  {
    "content": "\u2010 Who are all the programs for?\n\u2010 The church printed 'em up.", 
    "end": 965506, 
    "index": 223, 
    "start": 962336
  }, 
  {
    "content": "They're gonna have\nsome recycling to do.", 
    "end": 969010, 
    "index": 224, 
    "start": 965506
  }, 
  {
    "content": "I'm serious, Mom,\nit's turkey and bread.", 
    "end": 972096, 
    "index": 225, 
    "start": 969010
  }, 
  {
    "content": "Well, you better\nmake his a double.", 
    "end": 974473, 
    "index": 226, 
    "start": 972096
  }, 
  {
    "content": "You want to be an astronaut,", 
    "end": 976017, 
    "index": 227, 
    "start": 974473
  }, 
  {
    "content": "you're gonna need\nmeat on your bones.", 
    "end": 977268, 
    "index": 228, 
    "start": 976017
  }, 
  {
    "content": "HENRY:\nWe're past that.", 
    "end": 978728, 
    "index": 229, 
    "start": 977268
  }, 
  {
    "content": "These days he's all about\ngraphic design.", 
    "end": 981022, 
    "index": 230, 
    "start": 978728
  }, 
  {
    "content": "RUTH: I coulda sworn\nwe buried him in that suit.", 
    "end": 993075, 
    "index": 231, 
    "start": 989864
  }, 
  {
    "content": "HENRY:\nBuried who?", 
    "end": 995661, 
    "index": 232, 
    "start": 993075
  }, 
  {
    "content": "Your father.", 
    "end": 997163, 
    "index": 233, 
    "start": 995661
  }, 
  {
    "content": "( Henry talking, indistinct )", 
    "end": 1006464, 
    "index": 234, 
    "start": 1003085
  }, 
  {
    "content": "HENRY: ...help you out,\nget you back on your feet.", 
    "end": 1009383, 
    "index": 235, 
    "start": 1006464
  }, 
  {
    "content": "( car starts )", 
    "end": 1019310, 
    "index": 236, 
    "start": 1017892
  }, 
  {
    "content": "( bird singing )", 
    "end": 1096262, 
    "index": 237, 
    "start": 1094010
  }, 
  {
    "content": "\u2010 MATTHEW: The blanket.\n\u2010 RUTH: I made tuna fish salad.", 
    "end": 1102602, 
    "index": 238, 
    "start": 1099432
  }, 
  {
    "content": "( laughs )\nYou can say grace.", 
    "end": 1106147, 
    "index": 239, 
    "start": 1104103
  }, 
  {
    "content": "( Ruth continues, indistinct )", 
    "end": 1109108, 
    "index": 240, 
    "start": 1106147
  }, 
  {
    "content": "MATTHEW: We'll let the woods\nsay grace today. Come on. Sit. Sit.", 
    "end": 1111818, 
    "index": 241, 
    "start": 1109108
  }, 
  {
    "content": "What is that? Matthew.", 
    "end": 1139137, 
    "index": 242, 
    "start": 1136009
  }, 
  {
    "content": "I've had a beautiful experience,", 
    "end": 1142058, 
    "index": 243, 
    "start": 1139138
  }, 
  {
    "content": "and I want to share it with you.", 
    "end": 1143934, 
    "index": 244, 
    "start": 1142058
  }, 
  {
    "content": "Do you know what the Psalms say\nabout taking your own life?", 
    "end": 1147188, 
    "index": 245, 
    "start": 1143934
  }, 
  {
    "content": "\u2010 Matthew.\n\u2010 He's fine.", 
    "end": 1149398, 
    "index": 246, 
    "start": 1147188
  }, 
  {
    "content": "HENRY:\nIt's stealing.", 
    "end": 1152360, 
    "index": 247, 
    "start": 1150900
  }, 
  {
    "content": "MATTHEW: Because your life\nbelongs to God.", 
    "end": 1155613, 
    "index": 248, 
    "start": 1152360
  }, 
  {
    "content": "There was a Japanese solider.", 
    "end": 1161911, 
    "index": 249, 
    "start": 1159325
  }, 
  {
    "content": "World War II.\nHis masters tell him,", 
    "end": 1164538, 
    "index": 250, 
    "start": 1161911
  }, 
  {
    "content": "\"Whatever happens,\ndon't surrender.", 
    "end": 1166916, 
    "index": 251, 
    "start": 1164538
  }, 
  {
    "content": "Don't. Take your own life.\"", 
    "end": 1170127, 
    "index": 252, 
    "start": 1166916
  }, 
  {
    "content": "So he hides out", 
    "end": 1171921, 
    "index": 253, 
    "start": 1170127
  }, 
  {
    "content": "on an island in the Philippines.", 
    "end": 1173923, 
    "index": 254, 
    "start": 1171921
  }, 
  {
    "content": "Leaflets fall from the sky\ntelling him the war is over.", 
    "end": 1178010, 
    "index": 255, 
    "start": 1173923
  }, 
  {
    "content": "The Empire's dead.\nHis masters are dead.", 
    "end": 1180513, 
    "index": 256, 
    "start": 1178010
  }, 
  {
    "content": "But...", 
    "end": 1183015, 
    "index": 257, 
    "start": 1180513
  }, 
  {
    "content": "he doesn't believe 'em.", 
    "end": 1184433, 
    "index": 258, 
    "start": 1183015
  }, 
  {
    "content": "He kept fighting FDR until 1974.", 
    "end": 1187478, 
    "index": 259, 
    "start": 1184433
  }, 
  {
    "content": "Let's go home.\nI have chicken in the fridge.", 
    "end": 1190439, 
    "index": 260, 
    "start": 1187478
  }, 
  {
    "content": "You look...", 
    "end": 1192816, 
    "index": 261, 
    "start": 1190439
  }, 
  {
    "content": "at this town, the suffering,", 
    "end": 1195318, 
    "index": 262, 
    "start": 1192816
  }, 
  {
    "content": "you wonder...where was God?", 
    "end": 1198614, 
    "index": 263, 
    "start": 1195319
  }, 
  {
    "content": "Maybe the leaflets fell from the\nsky but you didn't believe them.", 
    "end": 1201575, 
    "index": 264, 
    "start": 1198614
  }, 
  {
    "content": "So...", 
    "end": 1203786, 
    "index": 265, 
    "start": 1201575
  }, 
  {
    "content": "I took a drive to the Walmart\nin Farmington,", 
    "end": 1207707, 
    "index": 266, 
    "start": 1203786
  }, 
  {
    "content": "and I took a walk here\nin the woods", 
    "end": 1209208, 
    "index": 267, 
    "start": 1207707
  }, 
  {
    "content": "where no one would\nhave to clean it up,", 
    "end": 1210960, 
    "index": 268, 
    "start": 1209208
  }, 
  {
    "content": "and I told God that\nI couldn't live without proof.", 
    "end": 1215255, 
    "index": 269, 
    "start": 1210960
  }, 
  {
    "content": "Then I fit the end\ninto my ear like this...", 
    "end": 1218717, 
    "index": 270, 
    "start": 1215255
  }, 
  {
    "content": "\u2010 ( cocks pistol )\n\u2010 RUTH: Matthew.", 
    "end": 1220636, 
    "index": 271, 
    "start": 1218718
  }, 
  {
    "content": "...and I heard it.", 
    "end": 1226307, 
    "index": 272, 
    "start": 1224306
  }, 
  {
    "content": "What?", 
    "end": 1228436, 
    "index": 273, 
    "start": 1227351
  }, 
  {
    "content": "( uncocks pistol )", 
    "end": 1233899, 
    "index": 274, 
    "start": 1232648
  }, 
  {
    "content": "God.", 
    "end": 1238904, 
    "index": 275, 
    "start": 1237319
  }, 
  {
    "content": "His voice.", 
    "end": 1243993, 
    "index": 276, 
    "start": 1242283
  }, 
  {
    "content": "I think we should\ncall Dr. Pierce.", 
    "end": 1250708, 
    "index": 277, 
    "start": 1248664
  }, 
  {
    "content": "This has nothing to do\nwith Dr. Pierce.", 
    "end": 1252960, 
    "index": 278, 
    "start": 1250708
  }, 
  {
    "content": "He scraped all that out of me.\nI'm healthy.", 
    "end": 1254503, 
    "index": 279, 
    "start": 1252960
  }, 
  {
    "content": "Just for a scan.", 
    "end": 1256422, 
    "index": 280, 
    "start": 1254503
  }, 
  {
    "content": "God helps those\nwho help themselves.", 
    "end": 1259175, 
    "index": 281, 
    "start": 1256422
  }, 
  {
    "content": "They said,\n\"Watch out for symptoms.\"", 
    "end": 1263596, 
    "index": 282, 
    "start": 1260509
  }, 
  {
    "content": "Headaches.\nRinging in the ears\u2010\u2010", 
    "end": 1266265, 
    "index": 283, 
    "start": 1263596
  }, 
  {
    "content": "MATTHEW:\nThis wasn't a ringing.", 
    "end": 1268517, 
    "index": 284, 
    "start": 1266265
  }, 
  {
    "content": "Saul heard it\non the road to Damascus,", 
    "end": 1270810, 
    "index": 285, 
    "start": 1268517
  }, 
  {
    "content": "knocked him flat on his back,", 
    "end": 1272437, 
    "index": 286, 
    "start": 1270810
  }, 
  {
    "content": "when he got up again,\nhe wasn't Saul.", 
    "end": 1273938, 
    "index": 287, 
    "start": 1272438
  }, 
  {
    "content": "He was Paul.", 
    "end": 1275608, 
    "index": 288, 
    "start": 1273939
  }, 
  {
    "content": "MATTHEW:\nShh, shh, shh, shh, shh.", 
    "end": 1287745, 
    "index": 289, 
    "start": 1286285
  }, 
  {
    "content": "I can hear it now.", 
    "end": 1292416, 
    "index": 290, 
    "start": 1290331
  }, 
  {
    "content": "Can you?", 
    "end": 1296086, 
    "index": 291, 
    "start": 1294376
  }, 
  {
    "content": "No.", 
    "end": 1299507, 
    "index": 292, 
    "start": 1297838
  }, 
  {
    "content": "We'll just sit here\nand be quiet.", 
    "end": 1302009, 
    "index": 293, 
    "start": 1299507
  }, 
  {
    "content": "HENRY: It's a work thing.\nYou two OK for a couple hours?", 
    "end": 1324156, 
    "index": 294, 
    "start": 1319693
  }, 
  {
    "content": "WENDELL:\nWe're good.", 
    "end": 1325616, 
    "index": 295, 
    "start": 1324156
  }, 
  {
    "content": "<i>( alarm beeps )\nFront door open.</i>", 
    "end": 1328035, 
    "index": 296, 
    "start": 1325616
  }, 
  {
    "content": "WENDELL: So what's the deal\nwith all the missing pieces?", 
    "end": 1331872, 
    "index": 297, 
    "start": 1328035
  }, 
  {
    "content": "Grandma?", 
    "end": 1332957, 
    "index": 298, 
    "start": 1331872
  }, 
  {
    "content": "You're not having a stroke,\nare you?", 
    "end": 1336836, 
    "index": 299, 
    "start": 1334458
  }, 
  {
    "content": "If I tell you something...", 
    "end": 1347263, 
    "index": 300, 
    "start": 1343968
  }, 
  {
    "content": "can you keep your mouth shut?", 
    "end": 1349890, 
    "index": 301, 
    "start": 1347263
  }, 
  {
    "content": "RUTH: See,", 
    "end": 1357064, 
    "index": 302, 
    "start": 1355980
  }, 
  {
    "content": "I can get lost in the past.", 
    "end": 1359108, 
    "index": 303, 
    "start": 1357064
  }, 
  {
    "content": "These are my breadcrumbs.", 
    "end": 1360985, 
    "index": 304, 
    "start": 1359108
  }, 
  {
    "content": "If I find a chess piece\nin the icebox,", 
    "end": 1363570, 
    "index": 305, 
    "start": 1360985
  }, 
  {
    "content": "well, I know it's now,\nnot then.", 
    "end": 1366282, 
    "index": 306, 
    "start": 1363571
  }, 
  {
    "content": "That I can find my way\nout of the woods.", 
    "end": 1370536, 
    "index": 307, 
    "start": 1367700
  }, 
  {
    "content": "Huh...", 
    "end": 1372413, 
    "index": 308, 
    "start": 1370536
  }, 
  {
    "content": "( laughs ) You think\nyour grandma's a fruitcake.", 
    "end": 1375416, 
    "index": 309, 
    "start": 1372413
  }, 
  {
    "content": "No.\nYou're a Timewalker.", 
    "end": 1378085, 
    "index": 310, 
    "start": 1375416
  }, 
  {
    "content": "Have you never heard\nof <i>Catacomb Drifter</i>", 
    "end": 1381088, 
    "index": 311, 
    "start": 1378085
  }, 
  {
    "content": "or <i>D For Destiny?</i>", 
    "end": 1383132, 
    "index": 312, 
    "start": 1381088
  }, 
  {
    "content": "<i>( game whooshes, beeps )</i>", 
    "end": 1387386, 
    "index": 313, 
    "start": 1384675
  }, 
  {
    "content": "Um, there's twelve levels,\nI mean, for now.", 
    "end": 1394184, 
    "index": 314, 
    "start": 1390306
  }, 
  {
    "content": "You know, they keep adding\nexpansion packs.", 
    "end": 1396770, 
    "index": 315, 
    "start": 1394184
  }, 
  {
    "content": "\u2010 <i>( whooshing )</i>\n\u2010 Oh, shit!", 
    "end": 1398856, 
    "index": 316, 
    "start": 1396770
  }, 
  {
    "content": "Got it.", 
    "end": 1401483, 
    "index": 317, 
    "start": 1399857
  }, 
  {
    "content": "RUTH:\nHow do you win?", 
    "end": 1403068, 
    "index": 318, 
    "start": 1401483
  }, 
  {
    "content": "It's not a game, exactly.", 
    "end": 1405613, 
    "index": 319, 
    "start": 1403068
  }, 
  {
    "content": "It never ends.", 
    "end": 1407114, 
    "index": 320, 
    "start": 1405613
  }, 
  {
    "content": "Anyway, Timewalkers\nare the most powerful", 
    "end": 1410451, 
    "index": 321, 
    "start": 1407114
  }, 
  {
    "content": "'cause they're the only avatars", 
    "end": 1411952, 
    "index": 322, 
    "start": 1410451
  }, 
  {
    "content": "that can actually\nkill the dead.", 
    "end": 1413871, 
    "index": 323, 
    "start": 1411952
  }, 
  {
    "content": "The dead, they're everywhere.\nSee?", 
    "end": 1417041, 
    "index": 324, 
    "start": 1413871
  }, 
  {
    "content": "<i>( zombies growling )</i>", 
    "end": 1418918, 
    "index": 325, 
    "start": 1417041
  }, 
  {
    "content": "Ha! And you know,\nthey're pissed off,", 
    "end": 1421170, 
    "index": 326, 
    "start": 1418918
  }, 
  {
    "content": "because we're alive\nand they're not.", 
    "end": 1424381, 
    "index": 327, 
    "start": 1421170
  }, 
  {
    "content": "You gotta stay sharp, because\nthey can change their skin,", 
    "end": 1427593, 
    "index": 328, 
    "start": 1424381
  }, 
  {
    "content": "and sometimes even\nlook like your allies.", 
    "end": 1429928, 
    "index": 329, 
    "start": 1427593
  }, 
  {
    "content": "Look, there goes another one.", 
    "end": 1433139, 
    "index": 330, 
    "start": 1431388
  }, 
  {
    "content": "See, what makes it so hard\nis that no one stays dead", 
    "end": 1435683, 
    "index": 331, 
    "start": 1433139
  }, 
  {
    "content": "when you kill them\u2010\u2010\nunless you're a Timewalker.", 
    "end": 1438437, 
    "index": 332, 
    "start": 1435684
  }, 
  {
    "content": "Theoretically, you could just\nkill your nemesis", 
    "end": 1441357, 
    "index": 333, 
    "start": 1438437
  }, 
  {
    "content": "and fix the whole timeline.", 
    "end": 1443734, 
    "index": 334, 
    "start": 1441357
  }, 
  {
    "content": "<i>( zombies screeching )</i>", 
    "end": 1446028, 
    "index": 335, 
    "start": 1443734
  }, 
  {
    "content": "But you gotta stay sharp.", 
    "end": 1448113, 
    "index": 336, 
    "start": 1446028
  }, 
  {
    "content": "Ohh.", 
    "end": 1457665, 
    "index": 337, 
    "start": 1456288
  }, 
  {
    "content": "<i>( alarm beeps )\nBack door open.</i>", 
    "end": 1468634, 
    "index": 338, 
    "start": 1466131
  }, 
  {
    "content": "You're back.", 
    "end": 1483899, 
    "index": 339, 
    "start": 1482439
  }, 
  {
    "content": "Go to bed, Ruth.", 
    "end": 1490572, 
    "index": 340, 
    "start": 1488320
  }, 
  {
    "content": "MATTHEW:\n<i>But a trumpet will sound</i>", 
    "end": 1499623, 
    "index": 341, 
    "start": 1497830
  }, 
  {
    "content": "<i>and the dead will be raised,\nimperishable,</i>", 
    "end": 1502166, 
    "index": 342, 
    "start": 1499623
  }, 
  {
    "content": "<i>and we will all...</i>", 
    "end": 1503794, 
    "index": 343, 
    "start": 1502167
  }, 
  {
    "content": "<i>...and this mortal\nmust put on immortality.</i>", 
    "end": 1506755, 
    "index": 344, 
    "start": 1503794
  }, 
  {
    "content": "( news broadcast on TV )", 
    "end": 1508757, 
    "index": 345, 
    "start": 1506755
  }, 
  {
    "content": "MAN: <i>Once again,\nreporting a suspected arson</i>", 
    "end": 1514596, 
    "index": 346, 
    "start": 1511343
  }, 
  {
    "content": "<i>at Juniper Hills Hospital,\nwith 14 confirmed dead.</i>", 
    "end": 1518934, 
    "index": 347, 
    "start": 1514596
  }, 
  {
    "content": "<i>The suspect\nconsidered dangerous.</i>", 
    "end": 1521228, 
    "index": 348, 
    "start": 1518934
  }, 
  {
    "content": "<i>Police have released a photo,\nbut not a name.</i>", 
    "end": 1525274, 
    "index": 349, 
    "start": 1521228
  }, 
  {
    "content": "WOMAN: <i>You can see the smoke\nbillowing from the rooftop...</i>", 
    "end": 1529028, 
    "index": 350, 
    "start": 1525274
  }, 
  {
    "content": "RUTH:\nMatthew.", 
    "end": 1530988, 
    "index": 351, 
    "start": 1529028
  }, 
  {
    "content": "YOUNG HENRY:\nAre you living or dead?", 
    "end": 1556472, 
    "index": 352, 
    "start": 1554094
  }, 
  {
    "content": "YOUNG RUTH:\nOh, long dead. Ancient history.", 
    "end": 1560100, 
    "index": 353, 
    "start": 1556472
  }, 
  {
    "content": "YOUNG HENRY: What's your name?", 
    "end": 1561685, 
    "index": 354, 
    "start": 1560100
  }, 
  {
    "content": "The badass avenger chick\nfrom G\u00edsla Saga. Uh...", 
    "end": 1565397, 
    "index": 355, 
    "start": 1561685
  }, 
  {
    "content": "\u2010 Thordis!\n\u2010 Oh!", 
    "end": 1567232, 
    "index": 356, 
    "start": 1565397
  }, 
  {
    "content": "You are your mother's son.", 
    "end": 1569234, 
    "index": 357, 
    "start": 1567232
  }, 
  {
    "content": "Ah, OK.", 
    "end": 1571737, 
    "index": 358, 
    "start": 1569234
  }, 
  {
    "content": "Got one.", 
    "end": 1573655, 
    "index": 359, 
    "start": 1571737
  }, 
  {
    "content": "OK. Who are you?", 
    "end": 1576241, 
    "index": 360, 
    "start": 1573655
  }, 
  {
    "content": "I'm smaller than a teacup.", 
    "end": 1578994, 
    "index": 361, 
    "start": 1576241
  }, 
  {
    "content": "Mmm. Smaller\nthan a teacup...", 
    "end": 1583123, 
    "index": 362, 
    "start": 1578994
  }, 
  {
    "content": "Did you say your prayers?", 
    "end": 1591340, 
    "index": 363, 
    "start": 1589588
  }, 
  {
    "content": "Yeah.", 
    "end": 1596053, 
    "index": 364, 
    "start": 1593842
  }, 
  {
    "content": "MATTHEW: Did you?", 
    "end": 1598180, 
    "index": 365, 
    "start": 1596053
  }, 
  {
    "content": "Good man.", 
    "end": 1605437, 
    "index": 366, 
    "start": 1603936
  }, 
  {
    "content": "He's a little old for that,\nisn't he?", 
    "end": 1616281, 
    "index": 367, 
    "start": 1614238
  }, 
  {
    "content": "Watching you take a bath?", 
    "end": 1619201, 
    "index": 368, 
    "start": 1616281
  }, 
  {
    "content": "Oh, he wasn't.", 
    "end": 1621245, 
    "index": 369, 
    "start": 1619201
  }, 
  {
    "content": "I'm his mother.", 
    "end": 1623372, 
    "index": 370, 
    "start": 1621245
  }, 
  {
    "content": "He's not blood.\nIt's different.", 
    "end": 1625791, 
    "index": 371, 
    "start": 1623372
  }, 
  {
    "content": "What did you do with the gun?\nI don't want it in the house.", 
    "end": 1631046, 
    "index": 372, 
    "start": 1628418
  }, 
  {
    "content": "God helps those\nwho help themselves.", 
    "end": 1634341, 
    "index": 373, 
    "start": 1631046
  }, 
  {
    "content": "Can't rely on the sheriff\nto keep our family safe.", 
    "end": 1637094, 
    "index": 374, 
    "start": 1634341
  }, 
  {
    "content": "\u2010 Matthew.\n\u2010 Top drawer in the dresser.", 
    "end": 1639471, 
    "index": 375, 
    "start": 1637094
  }, 
  {
    "content": "And before you tell me\nit's irresponsible,", 
    "end": 1641390, 
    "index": 376, 
    "start": 1639471
  }, 
  {
    "content": "the bullets are locked away.", 
    "end": 1643433, 
    "index": 377, 
    "start": 1641390
  }, 
  {
    "content": "He'll never find them.", 
    "end": 1646812, 
    "index": 378, 
    "start": 1644852
  }, 
  {
    "content": "( sighs )", 
    "end": 1656487, 
    "index": 379, 
    "start": 1655320
  }, 
  {
    "content": "WENDELL: <i>Theoretically, you\ncould just kill your nemesis,</i>", 
    "end": 1672754, 
    "index": 380, 
    "start": 1670043
  }, 
  {
    "content": "<i>fix the whole timeline.</i>", 
    "end": 1674423, 
    "index": 381, 
    "start": 1672754
  }, 
  {
    "content": "( panting )", 
    "end": 1679136, 
    "index": 382, 
    "start": 1677092
  }, 
  {
    "content": "( muttering )", 
    "end": 1683891, 
    "index": 383, 
    "start": 1681471
  }, 
  {
    "content": "MATTHEW:\n<i>The bullets are locked away.</i>", 
    "end": 1687769, 
    "index": 384, 
    "start": 1686435
  }, 
  {
    "content": "<i>He'll never find them.</i>", 
    "end": 1689479, 
    "index": 385, 
    "start": 1687769
  }, 
  {
    "content": "( doorbell rings )", 
    "end": 1724264, 
    "index": 386, 
    "start": 1722220
  }, 
  {
    "content": "( doorbell ringing )", 
    "end": 1729937, 
    "index": 387, 
    "start": 1727309
  }, 
  {
    "content": "( banging on door )", 
    "end": 1734900, 
    "index": 388, 
    "start": 1732940
  }, 
  {
    "content": "\u2010 Is Henry here?\n\u2010 No.", 
    "end": 1746453, 
    "index": 389, 
    "start": 1743283
  }, 
  {
    "content": "( banging )", 
    "end": 1748789, 
    "index": 390, 
    "start": 1747788
  }, 
  {
    "content": "MOLLY: Mrs. Deaver!", 
    "end": 1750498, 
    "index": 391, 
    "start": 1748789
  }, 
  {
    "content": "I think he's\u2010\u2010 he's lost.\nOr in trouble.", 
    "end": 1753960, 
    "index": 392, 
    "start": 1750498
  }, 
  {
    "content": "I need to find him.", 
    "end": 1755420, 
    "index": 393, 
    "start": 1753961
  }, 
  {
    "content": "<i>( alarm beeps )\nFront door open.</i>", 
    "end": 1759257, 
    "index": 394, 
    "start": 1756838
  }, 
  {
    "content": "When are we?", 
    "end": 1761551, 
    "index": 395, 
    "start": 1759257
  }, 
  {
    "content": "OK, Mrs. Deaver,\nit's important.", 
    "end": 1765806, 
    "index": 396, 
    "start": 1761551
  }, 
  {
    "content": "I think that something terrible\nis going to happen.", 
    "end": 1768809, 
    "index": 397, 
    "start": 1765806
  }, 
  {
    "content": "It's happened.", 
    "end": 1772270, 
    "index": 398, 
    "start": 1770143
  }, 
  {
    "content": "I saw you\nin my bedroom.", 
    "end": 1775774, 
    "index": 399, 
    "start": 1772270
  }, 
  {
    "content": "You were just a little girl.", 
    "end": 1779611, 
    "index": 400, 
    "start": 1777234
  }, 
  {
    "content": "I'm sorry.", 
    "end": 1782656, 
    "index": 401, 
    "start": 1781029
  }, 
  {
    "content": "\u2010 I'm so sorry.\n\u2010 No.", 
    "end": 1786660, 
    "index": 402, 
    "start": 1784533
  }, 
  {
    "content": "You did right.", 
    "end": 1788328, 
    "index": 403, 
    "start": 1786660
  }, 
  {
    "content": "But it didn't take.", 
    "end": 1792749, 
    "index": 404, 
    "start": 1790330
  }, 
  {
    "content": "He's back.", 
    "end": 1795293, 
    "index": 405, 
    "start": 1792749
  }, 
  {
    "content": "In the present,\nnot the past.", 
    "end": 1797796, 
    "index": 406, 
    "start": 1795293
  }, 
  {
    "content": "But I'm gonna fix it.", 
    "end": 1799423, 
    "index": 407, 
    "start": 1797796
  }, 
  {
    "content": "( locks door )", 
    "end": 1801383, 
    "index": 408, 
    "start": 1799423
  }, 
  {
    "content": "( muttering )", 
    "end": 1805554, 
    "index": 409, 
    "start": 1803343
  }, 
  {
    "content": "( needle scratches record )", 
    "end": 1809266, 
    "index": 410, 
    "start": 1807222
  }, 
  {
    "content": "( \"Blue Moon\"\nplaying on stereo )", 
    "end": 1817315, 
    "index": 411, 
    "start": 1814896
  }, 
  {
    "content": "Did, uh...", 
    "end": 1822112, 
    "index": 412, 
    "start": 1820152
  }, 
  {
    "content": "Did you hang the picture...", 
    "end": 1827992, 
    "index": 413, 
    "start": 1824280
  }, 
  {
    "content": "in the dining room?", 
    "end": 1830662, 
    "index": 414, 
    "start": 1827993
  }, 
  {
    "content": "That's where it belongs,\nisn't it?", 
    "end": 1833581, 
    "index": 415, 
    "start": 1830662
  }, 
  {
    "content": "I found it in the shed.", 
    "end": 1835666, 
    "index": 416, 
    "start": 1833581
  }, 
  {
    "content": "Remember this?", 
    "end": 1838295, 
    "index": 417, 
    "start": 1837294
  }, 
  {
    "content": "( turns up volume )", 
    "end": 1840589, 
    "index": 418, 
    "start": 1838295
  }, 
  {
    "content": "<i>\u266a Blue moon... \u266a</i>", 
    "end": 1847219, 
    "index": 419, 
    "start": 1842882
  }, 
  {
    "content": "RUTH: Who bought it?", 
    "end": 1849014, 
    "index": 420, 
    "start": 1847220
  }, 
  {
    "content": "<i>\u266a ...I was there for... \u266a</i>", 
    "end": 1851683, 
    "index": 421, 
    "start": 1849014
  }, 
  {
    "content": "You don't know?", 
    "end": 1852726, 
    "index": 422, 
    "start": 1851683
  }, 
  {
    "content": "I want to know\nif you know.", 
    "end": 1857021, 
    "index": 423, 
    "start": 1854352
  }, 
  {
    "content": "<i>\u266a Someone I really\ncould care for \u266a</i>", 
    "end": 1861567, 
    "index": 424, 
    "start": 1857021
  }, 
  {
    "content": "Your husband.", 
    "end": 1862819, 
    "index": 425, 
    "start": 1861568
  }, 
  {
    "content": "They played it\nat your wedding.", 
    "end": 1865530, 
    "index": 426, 
    "start": 1862819
  }, 
  {
    "content": "<i>\u266a Ooh \u266a</i>", 
    "end": 1869701, 
    "index": 427, 
    "start": 1865530
  }, 
  {
    "content": "<i>\u266a Ooh, ooh\u2010ooh\u2010ooh\u2010ooh \u266a</i>", 
    "end": 1874206, 
    "index": 428, 
    "start": 1869701
  }, 
  {
    "content": "<i>\u266a Ooh\u2010ooh\u2010ooh\u2010ee\u2010ooh\u2010ooh \u266a</i>", 
    "end": 1877834, 
    "index": 429, 
    "start": 1874206
  }, 
  {
    "content": "<i>\u266a Without a dream of my own \u266a</i>", 
    "end": 1883423, 
    "index": 430, 
    "start": 1879878
  }, 
  {
    "content": "<i>\u266a Ooh \u266a</i>", 
    "end": 1890931, 
    "index": 431, 
    "start": 1887552
  }, 
  {
    "content": "<i>\u266a Ooh, ooh, ooh\u2010ee\u2010ooh\u2010ooh \u266a</i>", 
    "end": 1895060, 
    "index": 432, 
    "start": 1890931
  }, 
  {
    "content": "<i>\u266a Ooh ooh, ooh\u2010ee\u2010ooh\u2010ooh \u266a</i>", 
    "end": 1898980, 
    "index": 433, 
    "start": 1896353
  }, 
  {
    "content": "RUTH: Upstairs.\nThe old safe.", 
    "end": 1902400, 
    "index": 434, 
    "start": 1898980
  }, 
  {
    "content": "What's the combination?", 
    "end": 1907489, 
    "index": 435, 
    "start": 1905362
  }, 
  {
    "content": "Your birthday.", 
    "end": 1913954, 
    "index": 436, 
    "start": 1911743
  }, 
  {
    "content": "<i>\u266a You saw me standing alone \u266a</i>", 
    "end": 1918166, 
    "index": 437, 
    "start": 1913954
  }, 
  {
    "content": "<i>\u266a Without a dream in my heart \u266a</i>", 
    "end": 1922212, 
    "index": 438, 
    "start": 1918166
  }, 
  {
    "content": "RUTH:\nOh, I\u2010\u2010", 
    "end": 1924381, 
    "index": 439, 
    "start": 1922212
  }, 
  {
    "content": "I feel light...in the head.", 
    "end": 1927634, 
    "index": 440, 
    "start": 1924381
  }, 
  {
    "content": "Would you make me\nsomething to eat?", 
    "end": 1933682, 
    "index": 441, 
    "start": 1930053
  }, 
  {
    "content": "( \"Blue Moon\"\ncontinues playing )", 
    "end": 1939104, 
    "index": 442, 
    "start": 1936351
  }, 
  {
    "content": "Grandma, what's he doing here?", 
    "end": 1946903, 
    "index": 443, 
    "start": 1944609
  }, 
  {
    "content": "When was the last time\nI bought you a present?", 
    "end": 1952075, 
    "index": 444, 
    "start": 1949197
  }, 
  {
    "content": "I want you to\nwalk down the hill,", 
    "end": 1954536, 
    "index": 445, 
    "start": 1952075
  }, 
  {
    "content": "take a taxi to the mall\nin Chester's Mill,", 
    "end": 1957164, 
    "index": 446, 
    "start": 1954536
  }, 
  {
    "content": "and let's make up\nfor lost time.", 
    "end": 1959416, 
    "index": 447, 
    "start": 1957164
  }, 
  {
    "content": "I don't think I should leave you\nalone with that dude.", 
    "end": 1961835, 
    "index": 448, 
    "start": 1959416
  }, 
  {
    "content": "RUTH: I'm your grandmother.\nI don't need a baby\u2010sitter.", 
    "end": 1964462, 
    "index": 449, 
    "start": 1961835
  }, 
  {
    "content": "Go on.", 
    "end": 1967883, 
    "index": 450, 
    "start": 1966423
  }, 
  {
    "content": "Go on.", 
    "end": 1979019, 
    "index": 451, 
    "start": 1976641
  }, 
  {
    "content": "<i>( alarm beeps )\nFront door open.</i>", 
    "end": 1981605, 
    "index": 452, 
    "start": 1979019
  }, 
  {
    "content": "Where did the boy go?", 
    "end": 1993408, 
    "index": 453, 
    "start": 1991698
  }, 
  {
    "content": "Oh...", 
    "end": 1998038, 
    "index": 454, 
    "start": 1996119
  }, 
  {
    "content": "he must be around here\nsomeplace.", 
    "end": 2000957, 
    "index": 455, 
    "start": 1998038
  }, 
  {
    "content": "He went out the front door.\nYou were just talking to him.", 
    "end": 2003501, 
    "index": 456, 
    "start": 2000957
  }, 
  {
    "content": "Was I?", 
    "end": 2006630, 
    "index": 457, 
    "start": 2005170
  }, 
  {
    "content": "Why don't you lie down?", 
    "end": 2011259, 
    "index": 458, 
    "start": 2009257
  }, 
  {
    "content": "If you feel light\u2010headed.", 
    "end": 2013553, 
    "index": 459, 
    "start": 2011259
  }, 
  {
    "content": "Good idea.", 
    "end": 2015055, 
    "index": 460, 
    "start": 2013553
  }, 
  {
    "content": "THE KID: On the sofa.", 
    "end": 2016765, 
    "index": 461, 
    "start": 2015055
  }, 
  {
    "content": "I think it's best if you stay\nwhere I can see you,", 
    "end": 2019725, 
    "index": 462, 
    "start": 2016765
  }, 
  {
    "content": "given your condition.", 
    "end": 2021352, 
    "index": 463, 
    "start": 2019725
  }, 
  {
    "content": "( thermometer beeping )", 
    "end": 2049965, 
    "index": 464, 
    "start": 2047420
  }, 
  {
    "content": "You're gonna make it.", 
    "end": 2053426, 
    "index": 465, 
    "start": 2051549
  }, 
  {
    "content": "Although you should be sick\u2010\u2010", 
    "end": 2055679, 
    "index": 466, 
    "start": 2053426
  }, 
  {
    "content": "out in the rain\nwith no jacket or shoes on.", 
    "end": 2058348, 
    "index": 467, 
    "start": 2055679
  }, 
  {
    "content": "It's 98.9.\nThat's a fever, right?", 
    "end": 2063144, 
    "index": 468, 
    "start": 2058348
  }, 
  {
    "content": "Quiz or essay?", 
    "end": 2065730, 
    "index": 469, 
    "start": 2063144
  }, 
  {
    "content": "I've been a teacher\nlong enough to know", 
    "end": 2067857, 
    "index": 470, 
    "start": 2065730
  }, 
  {
    "content": "what playin' hooky looks like.", 
    "end": 2069651, 
    "index": 471, 
    "start": 2067857
  }, 
  {
    "content": "Can you just...\ntell him I need to rest?", 
    "end": 2076825, 
    "index": 472, 
    "start": 2072696
  }, 
  {
    "content": "Your father?", 
    "end": 2079536, 
    "index": 473, 
    "start": 2078034
  }, 
  {
    "content": "He loves you, Henry.", 
    "end": 2082956, 
    "index": 474, 
    "start": 2080578
  }, 
  {
    "content": "He does.", 
    "end": 2084666, 
    "index": 475, 
    "start": 2082956
  }, 
  {
    "content": "It's just...", 
    "end": 2088086, 
    "index": 476, 
    "start": 2085917
  }, 
  {
    "content": "he was sick before you came\nto live with us.", 
    "end": 2091089, 
    "index": 477, 
    "start": 2088086
  }, 
  {
    "content": "He had headaches...", 
    "end": 2094092, 
    "index": 478, 
    "start": 2091089
  }, 
  {
    "content": "he'd see things\nthat weren't there.", 
    "end": 2095927, 
    "index": 479, 
    "start": 2094092
  }, 
  {
    "content": "It's called glioma.\nIt's a growth in the brain.", 
    "end": 2099514, 
    "index": 480, 
    "start": 2095927
  }, 
  {
    "content": "But\u2010\u2010But God saved him.", 
    "end": 2101433, 
    "index": 481, 
    "start": 2099514
  }, 
  {
    "content": "I know it's scary,\nhearing your father", 
    "end": 2104728, 
    "index": 482, 
    "start": 2102892
  }, 
  {
    "content": "talk about hurting himself,\nbut I'm gonna take him to Boston", 
    "end": 2108023, 
    "index": 483, 
    "start": 2104728
  }, 
  {
    "content": "for another scan,\nand he's gonna be just\u2010\u2010", 
    "end": 2109941, 
    "index": 484, 
    "start": 2108023
  }, 
  {
    "content": "No. He won't go.", 
    "end": 2112944, 
    "index": 485, 
    "start": 2109941
  }, 
  {
    "content": "He says that\nyou think he's sick,", 
    "end": 2117282, 
    "index": 486, 
    "start": 2114362
  }, 
  {
    "content": "but he's not.", 
    "end": 2119075, 
    "index": 487, 
    "start": 2117282
  }, 
  {
    "content": "If he was, he could just...", 
    "end": 2122203, 
    "index": 488, 
    "start": 2119075
  }, 
  {
    "content": "pray it away.", 
    "end": 2124039, 
    "index": 489, 
    "start": 2122203
  }, 
  {
    "content": "What were you doing outside...", 
    "end": 2129836, 
    "index": 490, 
    "start": 2127000
  }, 
  {
    "content": "in the rain\nwith no shoes on?", 
    "end": 2131755, 
    "index": 491, 
    "start": 2129836
  }, 
  {
    "content": "Did your father\nsend you out there?", 
    "end": 2138178, 
    "index": 492, 
    "start": 2135550
  }, 
  {
    "content": "\u2010 ( door opens )\n\u2010 MATTHEW: We OK?", 
    "end": 2140847, 
    "index": 493, 
    "start": 2138178
  }, 
  {
    "content": "( dog whimpering )", 
    "end": 2142807, 
    "index": 494, 
    "start": 2140847
  }, 
  {
    "content": "Fine, just, uh...", 
    "end": 2149439, 
    "index": 495, 
    "start": 2146978
  }, 
  {
    "content": "Henry's got a fever.", 
    "end": 2151691, 
    "index": 496, 
    "start": 2149439
  }, 
  {
    "content": "Is that right?", 
    "end": 2155945, 
    "index": 497, 
    "start": 2154569
  }, 
  {
    "content": "Well, you better\nrest up, then.", 
    "end": 2164537, 
    "index": 498, 
    "start": 2162369
  }, 
  {
    "content": "He was teaching me.", 
    "end": 2175882, 
    "index": 499, 
    "start": 2173713
  }, 
  {
    "content": "Listen...", 
    "end": 2181680, 
    "index": 500, 
    "start": 2179260
  }, 
  {
    "content": "just\u2010\u2010just tell him you hear it.", 
    "end": 2184516, 
    "index": 501, 
    "start": 2181680
  }, 
  {
    "content": "God's voice.\nOr whatever.", 
    "end": 2187644, 
    "index": 502, 
    "start": 2184516
  }, 
  {
    "content": "Just tell him\nwhat he wants to hear.", 
    "end": 2190105, 
    "index": 503, 
    "start": 2187644
  }, 
  {
    "content": "\u2010 ( knock on door )\n\u2010 YOUNG ALAN: Mrs. Deaver.", 
    "end": 2192440, 
    "index": 504, 
    "start": 2190105
  }, 
  {
    "content": "Sorry for the wait.", 
    "end": 2194192, 
    "index": 505, 
    "start": 2192440
  }, 
  {
    "content": "Cute.", 
    "end": 2208164, 
    "index": 506, 
    "start": 2206371
  }, 
  {
    "content": "But you know, lost pets\naren't really my department.", 
    "end": 2211292, 
    "index": 507, 
    "start": 2208164
  }, 
  {
    "content": "Henry loves that dog.", 
    "end": 2217298, 
    "index": 508, 
    "start": 2214129
  }, 
  {
    "content": "( sighs )\nShe's got no tags.", 
    "end": 2219592, 
    "index": 509, 
    "start": 2217298
  }, 
  {
    "content": "Matthew couldn't stand\nthe jingling.", 
    "end": 2223471, 
    "index": 510, 
    "start": 2221177
  }, 
  {
    "content": "Is that really\nwhy you're here?", 
    "end": 2228727, 
    "index": 511, 
    "start": 2226391
  }, 
  {
    "content": "I'm not sure if you want to talk\nto your sheriff, or your...", 
    "end": 2235734, 
    "index": 512, 
    "start": 2231813
  }, 
  {
    "content": "( chuckles )", 
    "end": 2238862, 
    "index": 513, 
    "start": 2237152
  }, 
  {
    "content": "I don't know what I am.", 
    "end": 2240905, 
    "index": 514, 
    "start": 2238862
  }, 
  {
    "content": "My friend.", 
    "end": 2246870, 
    "index": 515, 
    "start": 2244743
  }, 
  {
    "content": "Well...", 
    "end": 2249873, 
    "index": 516, 
    "start": 2246870
  }, 
  {
    "content": "you say he's never\nraised a hand,", 
    "end": 2251916, 
    "index": 517, 
    "start": 2249873
  }, 
  {
    "content": "so there's no legal avenue.", 
    "end": 2255086, 
    "index": 518, 
    "start": 2251916
  }, 
  {
    "content": "That's the badge talking.", 
    "end": 2258381, 
    "index": 519, 
    "start": 2256588
  }, 
  {
    "content": "As a friend...", 
    "end": 2267098, 
    "index": 520, 
    "start": 2263303
  }, 
  {
    "content": "I have some other ideas.", 
    "end": 2269225, 
    "index": 521, 
    "start": 2267098
  }, 
  {
    "content": "How would that look?", 
    "end": 2274606, 
    "index": 522, 
    "start": 2272103
  }, 
  {
    "content": "Minister's wife\ntakes up with widowed sheriff.", 
    "end": 2278484, 
    "index": 523, 
    "start": 2274606
  }, 
  {
    "content": "No. Not in this town.", 
    "end": 2282112, 
    "index": 524, 
    "start": 2278484
  }, 
  {
    "content": "Fuck this town.", 
    "end": 2284365, 
    "index": 525, 
    "start": 2282113
  }, 
  {
    "content": "Pardon my language.", 
    "end": 2287910, 
    "index": 526, 
    "start": 2285532
  }, 
  {
    "content": "You go buy yourself\na road atlas.", 
    "end": 2295543, 
    "index": 527, 
    "start": 2292707
  }, 
  {
    "content": "Put your finger down\nwherever you like.", 
    "end": 2298421, 
    "index": 528, 
    "start": 2295543
  }, 
  {
    "content": "Texas. Vancouver.", 
    "end": 2301549, 
    "index": 529, 
    "start": 2298421
  }, 
  {
    "content": "We'll make a fresh start.", 
    "end": 2304010, 
    "index": 530, 
    "start": 2301549
  }, 
  {
    "content": "\u2010 Alan, I can't leave.\n\u2010 Matthew? You said yourself", 
    "end": 2307889, 
    "index": 531, 
    "start": 2304010
  }, 
  {
    "content": "\u2010 he's not the man you married.\n\u2010 No...", 
    "end": 2310642, 
    "index": 532, 
    "start": 2307889
  }, 
  {
    "content": "I can't leave Henry.", 
    "end": 2312852, 
    "index": 533, 
    "start": 2310642
  }, 
  {
    "content": "I don't want you\nto leave your son.", 
    "end": 2316523, 
    "index": 534, 
    "start": 2314187
  }, 
  {
    "content": "All you need to do\nis pack a suitcase.", 
    "end": 2320193, 
    "index": 535, 
    "start": 2316523
  }, 
  {
    "content": "( door opening )", 
    "end": 2322320, 
    "index": 536, 
    "start": 2321236
  }, 
  {
    "content": "Oh. Sorry, I didn't know\u2010\u2010", 
    "end": 2325240, 
    "index": 537, 
    "start": 2323404
  }, 
  {
    "content": "I was\u2010\u2010\nI was just leaving anyway.", 
    "end": 2328785, 
    "index": 538, 
    "start": 2325240
  }, 
  {
    "content": "Thank you, Sheriff.", 
    "end": 2330703, 
    "index": 539, 
    "start": 2328785
  }, 
  {
    "content": "RUTH: <i>Did I ever tell you\nabout what happened to Puck?</i>", 
    "end": 2340296, 
    "index": 540, 
    "start": 2337585
  }, 
  {
    "content": "<i>Matthew said she must\nhave run off.</i>", 
    "end": 2342799, 
    "index": 541, 
    "start": 2340296
  }, 
  {
    "content": "<i>But I found a box of poison\nin the trash.</i>", 
    "end": 2352976, 
    "index": 542, 
    "start": 2350181
  }, 
  {
    "content": "<i>I always wondered...</i>", 
    "end": 2355103, 
    "index": 543, 
    "start": 2352976
  }, 
  {
    "content": "What did he do?", 
    "end": 2356521, 
    "index": 544, 
    "start": 2355103
  }, 
  {
    "content": "\u2010 Puck!\n\u2010 ( birds screeching )", 
    "end": 2375874, 
    "index": 545, 
    "start": 2371578
  }, 
  {
    "content": "<i>I used to see\nthe turkey vultures</i>", 
    "end": 2378334, 
    "index": 546, 
    "start": 2375874
  }, 
  {
    "content": "<i>wheeling around the sky\nout back, over the woods,</i>", 
    "end": 2381713, 
    "index": 547, 
    "start": 2378334
  }, 
  {
    "content": "<i>but I was too chickenshit\nto go look.</i>", 
    "end": 2383882, 
    "index": 548, 
    "start": 2381713
  }, 
  {
    "content": "<i>The thought of her\nbeing picked apart,</i>", 
    "end": 2385967, 
    "index": 549, 
    "start": 2383882
  }, 
  {
    "content": "<i>nobody to bury her...</i>", 
    "end": 2387260, 
    "index": 550, 
    "start": 2385967
  }, 
  {
    "content": "MATTHEW:\n<i>Over hard.</i>", 
    "end": 2408364, 
    "index": 551, 
    "start": 2406237
  }, 
  {
    "content": "THE KID:\nIsn't that how you like them?", 
    "end": 2410825, 
    "index": 552, 
    "start": 2408364
  }, 
  {
    "content": "\u2010 <i>\u266a Some people run \u266a</i>\n\u2010 Thank you.", 
    "end": 2418583, 
    "index": 553, 
    "start": 2415330
  }, 
  {
    "content": "<i>\u266a Some people crawl \u266a</i>", 
    "end": 2422921, 
    "index": 554, 
    "start": 2419834
  }, 
  {
    "content": "<i>\u266a Some people don't even \u266a</i>", 
    "end": 2427842, 
    "index": 555, 
    "start": 2424213
  }, 
  {
    "content": "<i>\u266a Move at all \u266a</i>", 
    "end": 2431429, 
    "index": 556, 
    "start": 2428927
  }, 
  {
    "content": "<i>\u266a Some roads lead forward \u266a</i>", 
    "end": 2436267, 
    "index": 557, 
    "start": 2433222
  }, 
  {
    "content": "<i>\u266a Some roads lead back \u266a</i>", 
    "end": 2440104, 
    "index": 558, 
    "start": 2437602
  }, 
  {
    "content": "<i>\u266a Some roads\nare bathed in light \u266a</i>", 
    "end": 2445777, 
    "index": 559, 
    "start": 2441981
  }, 
  {
    "content": "<i>\u266a Some wrapped in... \u266a</i>", 
    "end": 2447779, 
    "index": 560, 
    "start": 2445777
  }, 
  {
    "content": "I found these in the garbage.", 
    "end": 2450031, 
    "index": 561, 
    "start": 2447779
  }, 
  {
    "content": "It's a sedative.", 
    "end": 2453952, 
    "index": 562, 
    "start": 2451699
  }, 
  {
    "content": "<i>\u266a Oh, time \u266a</i>", 
    "end": 2456955, 
    "index": 563, 
    "start": 2453952
  }, 
  {
    "content": "<i>\u266a Where did you go? \u266a</i>", 
    "end": 2461708, 
    "index": 564, 
    "start": 2458789
  }, 
  {
    "content": "God helps those\nwho help themselves.", 
    "end": 2466130, 
    "index": 565, 
    "start": 2463378
  }, 
  {
    "content": "<i>\u266a Oh, time \u266a</i>", 
    "end": 2470635, 
    "index": 566, 
    "start": 2466130
  }, 
  {
    "content": "<i>\u266a Where did you go? \u266a</i>", 
    "end": 2474305, 
    "index": 567, 
    "start": 2470635
  }, 
  {
    "content": "<i>\u266a Some people never get \u266a</i>", 
    "end": 2481853, 
    "index": 568, 
    "start": 2477391
  }, 
  {
    "content": "<i>\u266a And some never give \u266a</i>", 
    "end": 2484649, 
    "index": 569, 
    "start": 2481854
  }, 
  {
    "content": "<i>\u266a Some people never die... \u266a</i>", 
    "end": 2489654, 
    "index": 570, 
    "start": 2485900
  }, 
  {
    "content": "It's better this way.", 
    "end": 2492740, 
    "index": 571, 
    "start": 2489654
  }, 
  {
    "content": "The two of us.", 
    "end": 2494617, 
    "index": 572, 
    "start": 2492740
  }, 
  {
    "content": "When I was younger,", 
    "end": 2500957, 
    "index": 573, 
    "start": 2498663
  }, 
  {
    "content": "every night after dinner\nI had a ritual.", 
    "end": 2504669, 
    "index": 574, 
    "start": 2500957
  }, 
  {
    "content": "Do you know what it was?", 
    "end": 2506796, 
    "index": 575, 
    "start": 2504669
  }, 
  {
    "content": "You'd take a bath.", 
    "end": 2511009, 
    "index": 576, 
    "start": 2509048
  }, 
  {
    "content": "Now, why in heaven\ndid I ever give that up?", 
    "end": 2516723, 
    "index": 577, 
    "start": 2513678
  }, 
  {
    "content": "I could draw one for you.", 
    "end": 2520435, 
    "index": 578, 
    "start": 2518349
  }, 
  {
    "content": "RUTH: Would you?", 
    "end": 2524856, 
    "index": 579, 
    "start": 2522562
  }, 
  {
    "content": "Mm\u2010hmm.", 
    "end": 2526232, 
    "index": 580, 
    "start": 2524856
  }, 
  {
    "content": "<i>\u266a Time, oh, good, good, time \u266a</i>", 
    "end": 2530987, 
    "index": 581, 
    "start": 2526232
  }, 
  {
    "content": "<i>\u266a Where did you go? \u266a</i>", 
    "end": 2535867, 
    "index": 582, 
    "start": 2532655
  }, 
  {
    "content": "\u2010 ( tap squeaks, water runs )\n\u2010 ( Ruth gasps )", 
    "end": 2561142, 
    "index": 583, 
    "start": 2558347
  }, 
  {
    "content": "\u2010 ( safe dial clicking )\n\u2010 One.", 
    "end": 2577325, 
    "index": 584, 
    "start": 2575573
  }, 
  {
    "content": "Twenty\u2010two...", 
    "end": 2584206, 
    "index": 585, 
    "start": 2581454
  }, 
  {
    "content": "( clicking )", 
    "end": 2585541, 
    "index": 586, 
    "start": 2584207
  }, 
  {
    "content": "Forty.", 
    "end": 2587627, 
    "index": 587, 
    "start": 2586542
  }, 
  {
    "content": "( clicks )", 
    "end": 2588836, 
    "index": 588, 
    "start": 2587627
  }, 
  {
    "content": "( hinges creak )", 
    "end": 2595093, 
    "index": 589, 
    "start": 2593257
  }, 
  {
    "content": "\u2010 ( whimpering )\n\u2010 THE KID: <i>Ruth!</i>", 
    "end": 2609816, 
    "index": 590, 
    "start": 2606771
  }, 
  {
    "content": "<i>Where'd you go?</i>", 
    "end": 2611484, 
    "index": 591, 
    "start": 2609816
  }, 
  {
    "content": "<i>Ruth?</i>", 
    "end": 2614320, 
    "index": 592, 
    "start": 2612902
  }, 
  {
    "content": "<i>Ruth, where'd you go?!</i>", 
    "end": 2619200, 
    "index": 593, 
    "start": 2617198
  }, 
  {
    "content": "<i>Where'd you go, Ruth?</i>", 
    "end": 2623704, 
    "index": 594, 
    "start": 2622161
  }, 
  {
    "content": "( skipping )\n<i>\u266a Love of my own\u2010\u2010 \u266a</i>", 
    "end": 2633005, 
    "index": 595, 
    "start": 2631087
  }, 
  {
    "content": "\u2010 <i>\u266a Love of my own\u2010\u2010 \u266a</i>\n\u2010 THE KID: Ruth?", 
    "end": 2635133, 
    "index": 596, 
    "start": 2633005
  }, 
  {
    "content": "Where'd you go?", 
    "end": 2636759, 
    "index": 597, 
    "start": 2635133
  }, 
  {
    "content": "<i>Ruth!</i>", 
    "end": 2640680, 
    "index": 598, 
    "start": 2638553
  }, 
  {
    "content": "\u2010 ( record skipping )\n\u2010 ( water running )", 
    "end": 2644475, 
    "index": 599, 
    "start": 2640680
  }, 
  {
    "content": "<i>Ruth? Ruth?</i>", 
    "end": 2659907, 
    "index": 600, 
    "start": 2657780
  }, 
  {
    "content": "<i>Ruth?</i>", 
    "end": 2661909, 
    "index": 601, 
    "start": 2660908
  }, 
  {
    "content": "<i>Ruth?</i>", 
    "end": 2664328, 
    "index": 602, 
    "start": 2662952
  }, 
  {
    "content": "<i>Ruth?\nWhere did you go?</i>", 
    "end": 2670459, 
    "index": 603, 
    "start": 2667165
  }, 
  {
    "content": "( floorboards creak )", 
    "end": 2682263, 
    "index": 604, 
    "start": 2680344
  }, 
  {
    "content": "Are you there?", 
    "end": 2690229, 
    "index": 605, 
    "start": 2687560
  }, 
  {
    "content": "RUTH:\nWho are you?", 
    "end": 2710625, 
    "index": 606, 
    "start": 2708206
  }, 
  {
    "content": "THE KID:\nI'm smaller than a teacup.", 
    "end": 2715129, 
    "index": 607, 
    "start": 2712710
  }, 
  {
    "content": "( The Kid cries out )", 
    "end": 2726015, 
    "index": 608, 
    "start": 2724263
  }, 
  {
    "content": "You're still young.\nYou'll remarry.", 
    "end": 2734732, 
    "index": 609, 
    "start": 2731062
  }, 
  {
    "content": "( overlapping distorted voices )", 
    "end": 2740821, 
    "index": 610, 
    "start": 2736484
  }, 
  {
    "content": "( voices, laughter )", 
    "end": 2747286, 
    "index": 611, 
    "start": 2744408
  }, 
  {
    "content": "<i>( crackling )</i>", 
    "end": 2768098, 
    "index": 612, 
    "start": 2766221
  }, 
  {
    "content": "It was a lovely wedding.", 
    "end": 2770101, 
    "index": 613, 
    "start": 2768099
  }, 
  {
    "content": "( panting )", 
    "end": 2775356, 
    "index": 614, 
    "start": 2772979
  }, 
  {
    "content": "( door opens )", 
    "end": 2785032, 
    "index": 615, 
    "start": 2783114
  }, 
  {
    "content": "YOUNG ALAN: <i>I don't want you\nto leave your son.</i>", 
    "end": 2795001, 
    "index": 616, 
    "start": 2791163
  }, 
  {
    "content": "<i>All you need to do\nis pack the suitcase.</i>", 
    "end": 2798087, 
    "index": 617, 
    "start": 2795001
  }, 
  {
    "content": "No.", 
    "end": 2810558, 
    "index": 618, 
    "start": 2809390
  }, 
  {
    "content": "Leave him.", 
    "end": 2813769, 
    "index": 619, 
    "start": 2811642
  }, 
  {
    "content": "Just leave him.", 
    "end": 2815438, 
    "index": 620, 
    "start": 2813769
  }, 
  {
    "content": "Please.", 
    "end": 2826615, 
    "index": 621, 
    "start": 2824405
  }, 
  {
    "content": "Just leave him.", 
    "end": 2828908, 
    "index": 622, 
    "start": 2826615
  }, 
  {
    "content": "( sighs )", 
    "end": 2833497, 
    "index": 623, 
    "start": 2831871
  }, 
  {
    "content": "( crying softly )", 
    "end": 2847887, 
    "index": 624, 
    "start": 2845634
  }, 
  {
    "content": "( barking )", 
    "end": 2849388, 
    "index": 625, 
    "start": 2847887
  }, 
  {
    "content": "( clock ticking )", 
    "end": 2853934, 
    "index": 626, 
    "start": 2851682
  }, 
  {
    "content": "WOMAN:\nRuth?", 
    "end": 2875122, 
    "index": 627, 
    "start": 2873204
  }, 
  {
    "content": "( low chatter )", 
    "end": 2877917, 
    "index": 628, 
    "start": 2875122
  }, 
  {
    "content": "( woman crying softly )", 
    "end": 2886717, 
    "index": 629, 
    "start": 2883464
  }, 
  {
    "content": "RUTH: Alan.", 
    "end": 2888386, 
    "index": 630, 
    "start": 2886717
  }, 
  {
    "content": "Who's in there?", 
    "end": 2891889, 
    "index": 631, 
    "start": 2889553
  }, 
  {
    "content": "Is it me?", 
    "end": 2894225, 
    "index": 632, 
    "start": 2891889
  }, 
  {
    "content": "I'm so sorry.", 
    "end": 2899522, 
    "index": 633, 
    "start": 2897353
  }, 
  {
    "content": "( crying )", 
    "end": 2901357, 
    "index": 634, 
    "start": 2899522
  }, 
  {
    "content": "( turns water on, off )", 
    "end": 2924255, 
    "index": 635, 
    "start": 2922086
  }, 
  {
    "content": "RUTH: Where in God's name\nhave you been?", 
    "end": 2935641, 
    "index": 636, 
    "start": 2933139
  }, 
  {
    "content": "I woke up and you were gone.", 
    "end": 2938310, 
    "index": 637, 
    "start": 2935641
  }, 
  {
    "content": "He's got a fever, Matthew.\nYou're gonna kill him out there.", 
    "end": 2942231, 
    "index": 638, 
    "start": 2938310
  }, 
  {
    "content": "Let's go to bed, Ruth.", 
    "end": 2943441, 
    "index": 639, 
    "start": 2942231
  }, 
  {
    "content": "This ends right now.", 
    "end": 2946402, 
    "index": 640, 
    "start": 2944483
  }, 
  {
    "content": "Tomorrow morning I'm taking you\nto see Dr. Vargas.", 
    "end": 2949071, 
    "index": 641, 
    "start": 2946402
  }, 
  {
    "content": "Whatever you thought\nyou heard out there\u2010\u2010", 
    "end": 2950948, 
    "index": 642, 
    "start": 2949071
  }, 
  {
    "content": "Henry heard it too.", 
    "end": 2952992, 
    "index": 643, 
    "start": 2950948
  }, 
  {
    "content": "Is <i>he</i> sick?", 
    "end": 2956954, 
    "index": 644, 
    "start": 2955744
  }, 
  {
    "content": "He told you what you wanted to\nhear because I told him to.", 
    "end": 2962293, 
    "index": 645, 
    "start": 2959290
  }, 
  {
    "content": "If I'd known you were\ngonna drag him out", 
    "end": 2964295, 
    "index": 646, 
    "start": 2962293
  }, 
  {
    "content": "all hours of the night,\nchasing God knows what...!", 
    "end": 2966797, 
    "index": 647, 
    "start": 2964295
  }, 
  {
    "content": "MATTHEW: Is that right?", 
    "end": 2972428, 
    "index": 648, 
    "start": 2971135
  }, 
  {
    "content": "Do you know\nwhat false witness is?", 
    "end": 2976807, 
    "index": 649, 
    "start": 2973762
  }, 
  {
    "content": "\"Yes,\" your mother told you\nto lie to me,", 
    "end": 2978684, 
    "index": 650, 
    "start": 2976807
  }, 
  {
    "content": "\u2010 or \"Yes\"\u2010\u2010\n\u2010 I heard it.", 
    "end": 2980352, 
    "index": 651, 
    "start": 2978684
  }, 
  {
    "content": "RUTH:\nHenry.", 
    "end": 2983272, 
    "index": 652, 
    "start": 2982104
  }, 
  {
    "content": "\u2010 MATTHEW: Good man.\n\u2010 Henry.", 
    "end": 2985357, 
    "index": 653, 
    "start": 2983272
  }, 
  {
    "content": "\u2010 Go to your room.\n\u2010 Tell him the truth.", 
    "end": 2987443, 
    "index": 654, 
    "start": 2985357
  }, 
  {
    "content": "It's not your job\nto protect me,", 
    "end": 2989361, 
    "index": 655, 
    "start": 2987443
  }, 
  {
    "content": "it's my job to protect you!", 
    "end": 2990988, 
    "index": 656, 
    "start": 2989361
  }, 
  {
    "content": "You'd hear it too if you\njust knew how to listen.", 
    "end": 2993240, 
    "index": 657, 
    "start": 2990988
  }, 
  {
    "content": "You killed the dog,\ndidn't you?", 
    "end": 2995701, 
    "index": 658, 
    "start": 2993240
  }, 
  {
    "content": "I know you did.", 
    "end": 2997703, 
    "index": 659, 
    "start": 2995701
  }, 
  {
    "content": "I can put up with a lot,", 
    "end": 2999330, 
    "index": 660, 
    "start": 2997703
  }, 
  {
    "content": "but I will not\nlet you hurt Henry.", 
    "end": 3001706, 
    "index": 661, 
    "start": 2999330
  }, 
  {
    "content": "I'm takin' him away. Tonight.", 
    "end": 3004375, 
    "index": 662, 
    "start": 3001706
  }, 
  {
    "content": "My bag is <i>packed.</i>", 
    "end": 3007880, 
    "index": 663, 
    "start": 3005419
  }, 
  {
    "content": "No, you won't.", 
    "end": 3012760, 
    "index": 664, 
    "start": 3010966
  }, 
  {
    "content": "You never do.", 
    "end": 3016138, 
    "index": 665, 
    "start": 3013969
  }, 
  {
    "content": "\u2010 What are you talking about?\n\u2010 Who's Dr. Vargas?", 
    "end": 3021852, 
    "index": 666, 
    "start": 3018349
  }, 
  {
    "content": "What?", 
    "end": 3023771, 
    "index": 667, 
    "start": 3021852
  }, 
  {
    "content": "\"We'll go see Dr. Vargas.\ntomorrow.\" Who's Dr. Vargas?", 
    "end": 3026649, 
    "index": 668, 
    "start": 3023771
  }, 
  {
    "content": "Somebody gave her carnations,\ndo you remember that?", 
    "end": 3031111, 
    "index": 669, 
    "start": 3028484
  }, 
  {
    "content": "Do you remember that?", 
    "end": 3032446, 
    "index": 670, 
    "start": 3031111
  }, 
  {
    "content": "She's...what do you call it?", 
    "end": 3036867, 
    "index": 671, 
    "start": 3033531
  }, 
  {
    "content": "Neurologist. Neurologist?", 
    "end": 3038661, 
    "index": 672, 
    "start": 3036867
  }, 
  {
    "content": "Yours, not mine.\nAnd you can't leave", 
    "end": 3040538, 
    "index": 673, 
    "start": 3038661
  }, 
  {
    "content": "because, see, 'cause you didn't.", 
    "end": 3042206, 
    "index": 674, 
    "start": 3040538
  }, 
  {
    "content": "And you can't leave\nbecause you didn't.", 
    "end": 3048295, 
    "index": 675, 
    "start": 3045125
  }, 
  {
    "content": "You're sick, Matthew.\nYou've lost touch with reality.", 
    "end": 3052174, 
    "index": 676, 
    "start": 3048295
  }, 
  {
    "content": "Says the woman that's arguing\nwith her dead husband.", 
    "end": 3055344, 
    "index": 677, 
    "start": 3052174
  }, 
  {
    "content": "Why don't you just ask me\nwhat you really want...", 
    "end": 3059765, 
    "index": 678, 
    "start": 3057263
  }, 
  {
    "content": "Why don't you just ask me\nwhat you really want to know?", 
    "end": 3062685, 
    "index": 679, 
    "start": 3059765
  }, 
  {
    "content": "Where are the bullets?", 
    "end": 3066438, 
    "index": 680, 
    "start": 3064186
  }, 
  {
    "content": "But I can't help you,\nbecause I'm not me, I'm you.", 
    "end": 3069275, 
    "index": 681, 
    "start": 3066438
  }, 
  {
    "content": "And you can't remember.", 
    "end": 3070401, 
    "index": 682, 
    "start": 3069275
  }, 
  {
    "content": "I should have\ntaken the gun", 
    "end": 3073571, 
    "index": 683, 
    "start": 3071735
  }, 
  {
    "content": "and shot you\nin your sleep.", 
    "end": 3075614, 
    "index": 684, 
    "start": 3073571
  }, 
  {
    "content": "\u2010 Why?\n\u2010 To protect our son!", 
    "end": 3078409, 
    "index": 685, 
    "start": 3075614
  }, 
  {
    "content": "It's a little late for that.\nWhat'd you ever do for Henry?", 
    "end": 3080703, 
    "index": 686, 
    "start": 3078409
  }, 
  {
    "content": "Nothing, because you were\ntoo chickenshit.", 
    "end": 3082371, 
    "index": 687, 
    "start": 3080703
  }, 
  {
    "content": "\u2010 I packed the bag!\n\u2010 And you unpacked it.", 
    "end": 3084957, 
    "index": 688, 
    "start": 3082371
  }, 
  {
    "content": "<i>Clothes back in the drawers,\ngun back in the linen closet.</i>", 
    "end": 3088294, 
    "index": 689, 
    "start": 3084957
  }, 
  {
    "content": "\u2010 ( mutters )\n\u2010 What?", 
    "end": 3095009, 
    "index": 690, 
    "start": 3092006
  }, 
  {
    "content": "I packed...the bullets.", 
    "end": 3100222, 
    "index": 691, 
    "start": 3097344
  }, 
  {
    "content": "I never unpacked 'em.", 
    "end": 3105227, 
    "index": 692, 
    "start": 3102349
  }, 
  {
    "content": "( dog barking )", 
    "end": 3107771, 
    "index": 693, 
    "start": 3105227
  }, 
  {
    "content": "( growling )", 
    "end": 3110816, 
    "index": 694, 
    "start": 3109481
  }, 
  {
    "content": "\u2010 Oh!\n\u2010 ( dog barks )", 
    "end": 3114236, 
    "index": 695, 
    "start": 3112318
  }, 
  {
    "content": "( continues barking )", 
    "end": 3116363, 
    "index": 696, 
    "start": 3114236
  }, 
  {
    "content": "( mumbling )", 
    "end": 3118240, 
    "index": 697, 
    "start": 3116363
  }, 
  {
    "content": "( barking continues )", 
    "end": 3124246, 
    "index": 698, 
    "start": 3121368
  }, 
  {
    "content": "( muttering )", 
    "end": 3147853, 
    "index": 699, 
    "start": 3146435
  }, 
  {
    "content": "Ahh!", 
    "end": 3151940, 
    "index": 700, 
    "start": 3150522
  }, 
  {
    "content": "MATTHEW: <i>Do you know\nwhat false witness is?</i>", 
    "end": 3171960, 
    "index": 701, 
    "start": 3168374
  }, 
  {
    "content": "<i>He was Paul...\nHe was Paul, he wasn't Saul.</i>", 
    "end": 3175422, 
    "index": 702, 
    "start": 3171960
  }, 
  {
    "content": "<i>Because your life belongs\nto God...belongs to God...</i>", 
    "end": 3179051, 
    "index": 703, 
    "start": 3175422
  }, 
  {
    "content": "<i>Before you tell me\nit's irresponsible,</i>", 
    "end": 3181053, 
    "index": 704, 
    "start": 3179051
  }, 
  {
    "content": "<i>the bullets are locked away.</i>", 
    "end": 3182179, 
    "index": 705, 
    "start": 3181053
  }, 
  {
    "content": "<i>He'll never find them.</i>", 
    "end": 3183305, 
    "index": 706, 
    "start": 3182179
  }, 
  {
    "content": "<i>The bullets are locked away...</i>", 
    "end": 3185140, 
    "index": 707, 
    "start": 3183305
  }, 
  {
    "content": "<i>But I can't help you\nbecause I'm not me...</i>", 
    "end": 3190020, 
    "index": 708, 
    "start": 3185140
  }, 
  {
    "content": "<i>...it wasn't ringing...\n...a beautiful experience...</i>", 
    "end": 3191939, 
    "index": 709, 
    "start": 3190020
  }, 
  {
    "content": "<i>...hear it too if you just\nknew how to listen, listen...</i>", 
    "end": 3195150, 
    "index": 710, 
    "start": 3191939
  }, 
  {
    "content": "<i>What'd you ever do\nfor Henry? Nothing.</i>", 
    "end": 3197486, 
    "index": 711, 
    "start": 3195150
  }, 
  {
    "content": "<i>'Cause you were\ntoo chickenshit!</i>", 
    "end": 3199530, 
    "index": 712, 
    "start": 3197486
  }, 
  {
    "content": "( gunshots )", 
    "end": 3201989, 
    "index": 713, 
    "start": 3199530
  }, 
  {
    "content": "( exhales )", 
    "end": 3208455, 
    "index": 714, 
    "start": 3206912
  }, 
  {
    "content": "( clattering )", 
    "end": 3230269, 
    "index": 715, 
    "start": 3227725
  }, 
  {
    "content": "( sobbing quietly )", 
    "end": 3237735, 
    "index": 716, 
    "start": 3236066
  }, 
  {
    "content": "( doorbell rings )", 
    "end": 3367948, 
    "index": 717, 
    "start": 3366238
  }, 
  {
    "content": "Ruth.", 
    "end": 3390387, 
    "index": 718, 
    "start": 3388468
  }, 
  {
    "content": "Hi. It's me, Alan.", 
    "end": 3393599, 
    "index": 719, 
    "start": 3390387
  }, 
  {
    "content": "I've been back\nfrom New Hampshire a few months.", 
    "end": 3397685, 
    "index": 720, 
    "start": 3393599
  }, 
  {
    "content": "Maybe you knew that.", 
    "end": 3400062, 
    "index": 721, 
    "start": 3397685
  }, 
  {
    "content": "Uh...", 
    "end": 3402399, 
    "index": 722, 
    "start": 3400063
  }, 
  {
    "content": "so, Del Bonsant called,", 
    "end": 3404776, 
    "index": 723, 
    "start": 3402399
  }, 
  {
    "content": "he said he heard gunshots\nup on North Prospect.", 
    "end": 3408447, 
    "index": 724, 
    "start": 3404776
  }, 
  {
    "content": "I could be dead in the ground,", 
    "end": 3410365, 
    "index": 725, 
    "start": 3408447
  }, 
  {
    "content": "folks would still ring me\nwhen they need a policeman.", 
    "end": 3412993, 
    "index": 726, 
    "start": 3410365
  }, 
  {
    "content": "So I figured that, uh,", 
    "end": 3416913, 
    "index": 727, 
    "start": 3412993
  }, 
  {
    "content": "I'd check and see\nif you needed one.", 
    "end": 3420124, 
    "index": 728, 
    "start": 3416913
  }, 
  {
    "content": "A cop.", 
    "end": 3423170, 
    "index": 729, 
    "start": 3421543
  }, 
  {
    "content": "( Alan clears throat )", 
    "end": 3428592, 
    "index": 730, 
    "start": 3427007
  }, 
  {
    "content": "Ruth.", 
    "end": 3430719, 
    "index": 731, 
    "start": 3428592
  }, 
  {
    "content": "It's 'cause of you.", 
    "end": 3432804, 
    "index": 732, 
    "start": 3430719
  }, 
  {
    "content": "That's why I came back.", 
    "end": 3440646, 
    "index": 733, 
    "start": 3438477
  }, 
  {
    "content": "I\u2010\u2010 I know it's not fair", 
    "end": 3444107, 
    "index": 734, 
    "start": 3441688
  }, 
  {
    "content": "to put this on you\nafter all these years,", 
    "end": 3447027, 
    "index": 735, 
    "start": 3444107
  }, 
  {
    "content": "and if you want me to,\nI'll go right now.", 
    "end": 3449529, 
    "index": 736, 
    "start": 3447027
  }, 
  {
    "content": "No. Please.", 
    "end": 3452949, 
    "index": 737, 
    "start": 3449529
  }, 
  {
    "content": "Don't leave.", 
    "end": 3454826, 
    "index": 738, 
    "start": 3452949
  }, 
  {
    "content": "Please don't leave.", 
    "end": 3457871, 
    "index": 739, 
    "start": 3455869
  }, 
  {
    "content": "I'm not goin' anywhere.", 
    "end": 3464086, 
    "index": 740, 
    "start": 3461958
  }, 
  {
    "content": "<i>( music playing )</i>", 
    "end": 3475972, 
    "index": 741, 
    "start": 3473720
  }, 
  {
    "content": "ROBOTIC VOICE:\n<i>Bad Robot.</i>", 
    "end": 3582829, 
    "index": 742, 
    "start": 3581369
  }
]

  start()
})()
