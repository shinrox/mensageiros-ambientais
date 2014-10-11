window.API = {}
API.videos = {}
API.hotspotOn = false
API.pauseMedia = (media)->
  return if !media
  if !media.paused
    media.pause()

API.playMedia = (media)->
  return if !media
  if media.paused
    media.play()

API.pauseAll = ()->
  def = new $.Deferred();
  videos = $("video")
  audios = $("audio")

  length = videos.length + audios.length
  current = 0
  return def.resolve() if length is 0

  $("video").each (i, e)->
    v = $(e)[0]
    if !v.paused
      v.pause()

    return

  $("audio").each (i, e)->
    a = $(e)[0]
    if !a.paused
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

  $('.theme').css({
    width: fixed.w
    height: fixed.h
    "margin-left": -(fixed.w / 2)
    "margin-top": -(fixed.h / 2)
  })


onResize = do ->
  throttle = 70 # tempo em ms
  lastExecution = new Date(new Date().getTime() - throttle)

  executeAction = () ->
    API.setSize()
    API.skrollr.refresh($(".theme *"))

  return ->
    if (lastExecution.getTime() + throttle) <= new Date().getTime()
      lastExecution = new Date()
      return executeAction.apply(this)

 
API.openHotSpot = (hotspot)->
  $(".hotspot-wrapper[data-hotspot='#{hotspot}']").fadeIn 500, (e)->
    $("body").css("overflow", "hidden")
    $this = $(this)
    API.hotspotOn = true;
    API.pauseAll().then ()->
      $this.find("video")[0].play();


$ ()->
  # Adiciona um handler para ajustar o tamanho da página ao  
  # redimensionar a janela do browser
  $(window).unbind('resize', onResize).bind 'resize', onResize

  API.setSize()


API.events =
  data_startintro: (dir)->
    API.playMedia(API.videos.v1)

  data1700: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2)
      API.playMedia(API.audios.a2)
    else
      API.pauseMedia(API.videos.v2)
      API.pauseMedia(API.audios.a2)

  data_endintro: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v1)
    else
      API.playMedia(API.videos.v1)

  data4000: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v3)
    else
      API.pauseMedia(API.videos.v3)

  data4500: (dir)->
    if dir is 'up'
      API.playMedia(API.videos.v2)
    else
      API.pauseMedia(API.videos.v2)

  data10100: (dir)->
    API.pauseMedia(API.videos.v3)

  data20000: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2)
    else
      if !API.audios.a2.alreadyPlayed
        API.playMedia(API.audios.a2)

  data22000: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v7)
    else
      API.pauseMedia(API.videos.v7)

  data27500: (dir)->
    API.pauseMedia(API.videos.v7)


  data33000: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v9)
    else
      API.pauseMedia(API.videos.v9)
  
  data50100: (dir)->
    API.pauseMedia(API.videos.v9)

  data60500: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a13)
    else
      API.pauseMedia(API.audios.a13)

  data72000: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a13)
    else
      API.playMedia(API.audios.a13)

  data101400: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a2_1)
    else
      API.pauseMedia(API.audios.a2_1)

  data113400: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2_1)
    else
      API.playMedia(API.audios.a2_1)

  data119800: (dir)->
    if dir is 'down'
      API.playMedia(API.audios.a2_6)
    else
      API.pauseMedia(API.audios.a2_6)

  data123200: (dir)->
    if dir is 'down'
      API.pauseMedia(API.audios.a2_6)
    else
      API.playMedia(API.audios.a2_6)

  data123300: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_7)
    else
      API.pauseMedia(API.videos.v2_7)

  data126300: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_7)
    else
      API.playMedia(API.videos.v2_7)

  data129300: (dir)->
    if dir is 'down'
      API.playMedia(API.videos.v2_9)
    else
      API.pauseMedia(API.videos.v2_9)

  data132300: (dir)->
    if dir is 'down'
      API.pauseMedia(API.videos.v2_9)
    else
      API.playMedia(API.videos.v2_9)

Pace.on 'hide', ->
  $("#loading").fadeOut()
  API.videos =
    v1: $(".scene-1 video")[0]
    v2: $(".scene-2 video")[0]
    v3: $(".scene-3 video")[0]
    v7: $(".scene-7 video")[0]
    v9: $(".scene-9 video")[0]
    v2_7: $(".scene-2-7 video")[0]
    v2_9: $(".scene-2-9 video")[0]

  API.audios =
    a2: $(".scene-2 audio")[0]
    a13: $(".scene-13 audio")[0]
    a2_1: $(".scene-2-1 audio")[0]
    a2_6: $(".scene-2-6 audio")[0]

  for own key, video of API.videos
    video.onended = ()->
      @alreadyPlayed = true

  for own key, audio of API.audios
    audio.onended = ()->
      @alreadyPlayed = true

  API.skrollr = skrollr.init({
    smoothScrolling: true
    smoothScrollingDuration: 1000
    constants:
      startintro: 0
      endintro: 1800
    keyframe: (element, name, dir)->
      fn = API.events[name]

      if fn?
        console.log "Executando #{name}, #{dir}"
        fn(dir)

      else
        console.log "definir função para evento #{name}"

  })
  


  $(".hotspot-area").on "click", ()->
    API.openHotSpot($(this).data("hotspot"))

  $(".hotspot-wrapper .close").on "click", ()->
    $("body").css("overflow", "")
    $this = $(this)
    API.pauseAll().then ()->
      API.hotspotOn = false;
      $(".hotspot-wrapper").fadeOut(400)

$(window).on "unload", ()->
  window.scrollTo(0,0)