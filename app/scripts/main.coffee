window.API = {}
API.videos = {}
API.hotspotOn = false
API.playPauseVideo = (id, play)->
  video = API.videos["v" + id]
  return if !video
  if play and video.paused
    video.play()
  else if !play
    if !video.paused
      video.pause()

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
    $this = $(this)
    API.hotspotOn = true;
    API.pauseAll().then ()->
      $this.find("video")[0].play();


$ ()->
  # Adiciona um handler para ajustar o tamanho da página ao  
  # redimensionar a janela do browser
  $(window).unbind('resize', onResize).bind 'resize', onResize

  API.setSize()

$(window).load ->
  API.videos =
    v1: $(".scene-1 video")[0]
    v2: $(".scene-2 video")[0]
    v3: $(".scene-3 video")[0]
    v7: $(".scene-7 video")[0]
    v9: $(".scene-9 video")[0]
    v13: $(".scene-13 video")[0]
    v14: $(".scene-14 video")[0]

  API.skrollr = skrollr.init({
    render: (data)->

      return if API.hotspotOn
      if data.curTop >= 0 and data.curTop <= 1500
        API.playPauseVideo(1, true)
      else
        API.playPauseVideo(1, false)

      if data.curTop >= 1300 and data.curTop <= 22000
        $(".scene-2 audio")[0].play()

        API.playPauseVideo(2, data.curTop <= 4500)
      else
        API.playPauseVideo(2, false)
        
        $(".scene-2 audio")[0].pause()

      if data.curTop >= 4000 and data.curTop <= 10100
        API.playPauseVideo(3, true)
        
      else
        API.playPauseVideo(3, false)

      if data.curTop >= 20000 and data.curTop <= 27500
        API.playPauseVideo(7, true)
        
      else
        API.playPauseVideo(7, false)

      if data.curTop >= 29500 and data.curTop <= 40100
        API.playPauseVideo(9, true)
        
      else
        API.playPauseVideo(9, false)

      if data.curTop >= 64500 and data.curTop <= 74500
        API.playPauseVideo(13, true)
        
      else
        API.playPauseVideo(13, false)

      if data.curTop > 68500 and data.curTop <= 80000
        API.playPauseVideo(14, true)
        
      else
        API.playPauseVideo(14, false)
        
  })


  $(".hotspot-area").on "click", ()->
    API.openHotSpot($(this).data("hotspot"))

  $(".hotspot-wrapper .close").on "click", ()->
    $this = $(this)
    API.pauseAll().then ()->
      API.hotspotOn = false;
      $(".hotspot-wrapper").fadeOut(400)