window.API = {}
API.videos = {}
API.hotspotOn = false
API.continuePlaying = []
API.pauseMedia = (media)->
  return if !media
  if !media.paused
    media.pause()

API.playMedia = (media)->
  return if !media
  if media.paused
    media.alreadyPlayed = false
    media.play()

API.resumePlaying = ()->
  for media in API.continuePlaying
    API.playMedia(media)

API.pauseAll = ()->
  API.continuePlaying = []
  def = new $.Deferred();
  videos = $("video")
  audios = $("audio")

  length = videos.length + audios.length
  current = 0
  return def.resolve() if length is 0

  $("video").each (i, e)->
    v = $(e)[0]
    if !v.paused
      API.continuePlaying.push(v)
      v.pause()

    return

  $("audio").each (i, e)->
    a = $(e)[0]
    if !a.paused
      API.continuePlaying.push(a)
      a.pause()

    return

  def.resolve()

  return def.promise()

API.setSize = ()->
  base = 
    w: 1144
    h: 643

  current =
    w: $(window).width()
    h: $(window).height()


  if current.w > base.w
    if current.h <= base.h
      percent = current.h / base.h
    else
      percent = current.w / base.w

    if base.h * percent > current.h
      percent = current.h / base.h
  else
    percent = current.w / base.w

  fixed = 
    w: base.w * percent
    h: base.h * percent

  $('.theme, .hotspot-wrapper .img-wrapper').css({
    width: fixed.w
    height: fixed.h
    "margin-left": -(fixed.w / 2)
    "margin-top": -(fixed.h / 2)
  })

onResize = do ->
  throttle = 70 # tempo em ms
  lastExecution = new Date(new Date().getTime() - throttle)

  executeAction = () ->
    return if !API.skrollr?
    API.setSize()

  return ->
    if (lastExecution.getTime() + throttle) <= new Date().getTime()
      lastExecution = new Date()
      return executeAction.apply(this)

 
API.openHotSpot = (hotspot)->
  API.pauseAll().then ()->
    $(".hotspot-wrapper[data-hotspot='#{hotspot}']").fadeIn 500, (e)->
      $("body").css("overflow", "hidden")
      $this = $(this)
      API.hotspotOn = true;
      video = $this.find("video")

      if video.length > 0
        video[0].play();


$ ()->
  # Adiciona um handler para ajustar o tamanho da página ao  
  # redimensionar a janela do browser
  $(window).unbind('resize', onResize).bind 'resize', onResize

  API.setSize()


API.events =
  data_startintro: (dir)->
    API.playMedia(API.videos.v1)
  
  data_endintro: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v1)
    else
      API.playMedia(API.videos.v1)

  data_startbee: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2)
      API.playMedia(API.audios.a2)
    else
      API.pauseMedia(API.videos.v2)
      API.pauseMedia(API.audios.a2)

  data_endbee: (dir)->
    if dir is 'up'
      API.playMedia(API.videos.v2)
    else
      API.pauseMedia(API.videos.v2)

  data_startclaudia: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a2)
    else
      API.pauseMedia(API.audios.a2)

  data_endclaudia: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2)
    else
      if !API.audios.a2.alreadyPlayed
        API.playMedia(API.audios.a2)

  data_startwelcome: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3)
    else
      API.pauseMedia(API.videos.v3)

  data_endwelcome: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v3)
    else
      if !API.videos.v3.alreadyPlayed
        API.playMedia(API.videos.v3)

  data_startkidsenv: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v7)
    else
      API.pauseMedia(API.videos.v7)

  data_endkidsenv: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v7)
    else
      if !API.videos.v7.alreadyPlayed
        API.playMedia(API.videos.v7)


  data_startfelipe: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v9)
    else
      API.pauseMedia(API.videos.v9)
  
  data_endfelipe: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v9)
    else
      if !API.videos.v9.alreadyPlayed
        API.playMedia(API.videos.v9)

  data_startpano: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a13)
    else
      API.pauseMedia(API.audios.a13)

  data_endpano: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a13)
    else
      API.playMedia(API.audios.a13)

  data_starteldorado: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a2_1)
    else
      API.pauseMedia(API.audios.a2_1)

  data_endeldorado: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2_1)
    else
      API.playMedia(API.audios.a2_1)

  data_startmiriam: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a2_6)
    else
      API.pauseMedia(API.audios.a2_6)

  data_endmiriam: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2_6)
    else
      if !API.audios.a2_6.alreadyPlayed
        API.playMedia(API.audios.a2_6)

  data_startjosue: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_7)
    else
      API.pauseMedia(API.videos.v2_7)

  data_endjosue: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_7)
    else
      if !API.videos.v2_7.alreadyPlayed
        API.playMedia(API.videos.v2_7)

  data_startcomposting: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_9)
    else
      API.pauseMedia(API.videos.v2_9)

  data_endcomposting: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_9)
    else
      if !API.videos.v2_9.alreadyPlayed
        API.playMedia(API.videos.v2_9)

  data_startexpress: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_10)
    else
      API.pauseMedia(API.videos.v2_10)

  data_endexpress: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_10)
    else
      if !API.videos.v2_10.alreadyPlayed
        API.playMedia(API.videos.v2_10)


  data_startrecycling: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_12)
    else
      API.pauseMedia(API.videos.v2_12)

  data_endrecycling: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_12)
    else
      if !API.videos.v2_9.alreadyPlayed
        API.playMedia(API.videos.v2_12)

  data_startreciclamundo: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_14)
    else
      API.pauseMedia(API.videos.v2_12)

  data_endreciclamundo: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_14)
    else
      if !API.videos.v2_9.alreadyPlayed
        API.playMedia(API.videos.v2_14)

  data_startong: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3_3)
    else
      API.pauseMedia(API.videos.v3_3)

  data_endong: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v3_3)
    else
      if !API.videos.v3_3.alreadyPlayed
        API.playMedia(API.videos.v3_3)

  data_startgenival: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3_6)
    else
      API.pauseMedia(API.videos.v3_6)

  data_endgenival: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v3_6)
    else
      if !API.videos.v3_6.alreadyPlayed
        API.playMedia(API.videos.v3_6)

  data_startcidadessemfome: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3_10)
    else
      API.pauseMedia(API.videos.v3_10)

  data_endcidadessemfome: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v3_10)
    else
      if !API.videos.v3_6.alreadyPlayed
        API.playMedia(API.videos.v3_10)

  data_startmariaejoaquim: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3_14)
    else
      API.pauseMedia(API.videos.v3_14)

# API.paceFix = do ->
#   countdown = 
#     current: 0
#     reset: ()->
#       @current = 0
#     increase: ()->
#       @current++

#   API.lastPercent = Pace.bar.progress

#   return ()->
#     if API.lastPercent is Pace.bar.progress and Pace.bar.progress > 90
#       countdown.increase()
      
#       if countdown.current >= 9 and Pace.bar.progress > 90
#         countdown.reset()
#         Pace.stop()
#     else
#       countdown.reset()
    

# API.paceInterval = setInterval API.paceFix, 600
      
Pace.on 'hide', ->
  # clearInterval(API.paceInterval)
  $("#loading").fadeOut()
  API.videos =
    v1: $(".scene-1 video")[0]
    v2: $(".scene-2 video")[0]
    v3: $(".scene-3 video")[0]
    v7: $(".scene-7 video")[0]
    v9: $(".scene-9 video")[0]
    v2_7: $(".scene-2-7 video")[0]
    v2_9: $(".scene-2-9 video")[0]
    v2_10: $(".scene-2-10 video")[0]
    v2_12: $(".scene-2-12 video")[0]
    v2_14: $(".scene-2-14 video")[0]
    v3_3: $(".scene-3-3 video")[0]
    v3_6: $(".scene-3-6 video")[0]
    v3_10: $(".scene-3-10 video")[0]
    v3_14: $(".scene-3-14 video")[0]

  API.audios =
    a2: $(".scene-2 audio")[0]
    a13: $(".scene-13 audio")[0]
    a2_1: $(".scene-2-1 audio")[0]
    a2_6: $(".scene-2-6 audio")[0]

  $("video, audio").each (i, e)->
    media = $(e).get(0)
    media.onended = ()->
      $(".hotspot-wrapper:visible").find('.close').click();
      @alreadyPlayed = true

  API.skrollr = skrollr.init({
    smoothScrolling: true
    smoothScrollingDuration: 1000
    constants:
      startintro: 0
      endintro: 1800
      startbee: 1700
      endbee: 4500
      startclaudia: 1600
      endclaudia: 20000
      startwelcome: 4000
      endwelcome: 10100
      startkidsenv: 22000
      endkidsenv: 27500
      startfelipe: 33000
      endfelipe: 50100
      startpano: 60500
      endpano: 72000
      starteldorado: 101400
      endeldorado: 113400
      startmiriam: 119800
      endmiriam: 123200
      startjosue: 123300
      endjosue: 126300
      startcomposting: 129300
      endcomposting: 132300
      startexpress: 132300
      endexpress: 135300
      startrecycling: 140300
      endrecycling: 145200
      startreciclamundo: 146000
      endreciclamundo: 154000
      startong: 155100
      endong: 162000
      startgenival: 166500
      endgenival: 170000
      startcidadessemfome: 175000
      endcidadessemfome: 181000
      startmariaejoaquim: 189000
    keyframe: (element, name, dir)->
      fn = API.events[name]

      if fn?
        fn(dir)
      else
        console.log "definir função para evento #{name}"

  })
  


  $(".hotspot-area").on "click", (e)->
    e.preventDefault();
    e.stopPropagation();
    API.openHotSpot($(this).data("hotspot"))

  $(".hotspot-wrapper .close").on "click", ()->
    $("body").css("overflow", "")
    $this = $(this)

    API.pauseMedia($(".hotspot-wrapper:visible video")[0])
    API.hotspotOn = false;
    $(".hotspot-wrapper:visible").fadeOut 400, ()->
      API.resumePlaying()

  $(".link-area").on "click", (e)->
    e.preventDefault();
    e.stopPropagation();
    window.open($(this).data('link'));

  $("#project-wrapper .share a").on "click", (e)->
    e.preventDefault();
    e.stopPropagation();
    window.open($(this).attr('href'));

$(window).on "unload", ()->
  window.scrollTo(0,0)