window.API = {}
API.videos = {}
API.hotspotOn = false
API.playPauseMedia = (media, play)->
  return if !media
  if play and media.paused
    media.play()
  else if !play
    if !media.paused
      media.pause()

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


Pace.on 'hide', ->
  $("#loading").fadeOut()
  API.videos =
    v1: $(".scene-1 video")[0]
    v2: $(".scene-2 video")[0]
    v3: $(".scene-3 video")[0]
    v7: $(".scene-7 video")[0]
    v9: $(".scene-9 video")[0]

  API.audios =
    a2: $(".scene-2 audio")[0]
    a13: $(".scene-13 audio")[0]



  API.skrollr = skrollr.init({
    smoothScrolling: true
    smoothScrollingDuration: 1000
    render: (data)->
      # return API.playPauseMedia(13, data.curTop >= 60500 and data.curTop <= 68500);
      
      if data.curTop >= 0 and data.curTop <= 1500
        API.playPauseMedia(API.videos.v1, true)
      else
        API.playPauseMedia(API.videos.v1, false)

      if data.curTop >= 1300 and data.curTop <= 20000
        API.playPauseMedia(API.audios.a2, true)
        API.playPauseMedia(API.videos.v2, data.curTop <= 4500)
      else
        API.playPauseMedia(API.audios.a2, false)
        API.playPauseMedia(API.videos.v2, false)

      if data.curTop >= 4000 and data.curTop <= 10100
        API.playPauseMedia(API.videos.v3, true)
        
      else
        API.playPauseMedia(API.videos.v3, false)

      if data.curTop >= 22000 and data.curTop <= 27500
        API.playPauseMedia(API.videos.v7, true)
        
      else
        API.playPauseMedia(API.videos.v7, false)

      if data.curTop >= 33000 and data.curTop <= 50100
        API.playPauseMedia(API.videos.v9, true)
        
      else
        API.playPauseMedia(API.videos.v9, false)

      if data.curTop >= 60500 and data.curTop <= 72000
        API.playPauseMedia(API.audios.a13, true)
        
      else
        API.playPauseMedia(API.audios.a13, false)

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