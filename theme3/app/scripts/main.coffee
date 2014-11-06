window.API = {}
API.videos = {}
API.hotspotOn = false
API.continuePlaying = []
API.pauseMedia = (media, dir)->
  return if !media
  if !media.paused
    media.pause()
    # source = $(media).find('source')[0]
    # s = source.src
    # media.src = ""
    # media.load()
    # media.src = s

API.playMedia = (media)->
  return if !media
  if media.paused
    media.alreadyPlayed = false
    media.play()

API.playPauseMedia = (media, play)->
  return if !media
  if play and media.paused
    API.playMedia(media)
  else if !play and !media.paused
    API.pauseMedia(media)


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
    return if !API.skrollr?
    API.setSize()
    API.skrollr.refresh($(".theme *"))

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

      if video. length > 0
        video[0].play();


$ ()->
  # Adiciona um handler para ajustar o tamanho da página ao  
  # redimensionar a janela do browser
  $(window).unbind('resize', onResize).bind 'resize', onResize

  API.setSize()


API.events =
  startintro: (el, dir)->
    API.playMedia(el)

  endintro: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startalimentacao: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endalimentacao: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startbandeira: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endbandeira: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startoquealimenta: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endoquealimenta: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startmsgcazita: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endmsgcazita: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startcazita: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  endcazita: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startdaniela: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  enddaniela: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startfoodrev: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  endfoodrev: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startseplantar: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  endseplantar: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startdesperdicio: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  enddesperdicio: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  endreginaup: (el, dir)->
    API.pauseMedia(el)

  endreginadown: (el)->
    API.pauseMedia(el)

  starttangerina: (el, dir)->
    API.playPauseMedia(el, dir is 'down')
    
  endtangerina: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startpomba: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

API.scenes = do->
  scenes = {}
  dur = 4500
  current = 2000
  for scene in [1..32]
    scenes["#{scene}beginleave"] = current
    scenes["#{scene}endleave"] = scenes["#{scene}beginleave"] + 1000
    current += (dur)

  return scenes

Pace.on 'hide', ->
  $("#loading").fadeOut()

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
      endintro: 2500
      startalimentacao:6000
      endalimentacao: 9500
      startbandeira: 11500
      endbandeira: 16000
      startoquealimenta: 27000
      endoquealimenta: 32000
      startmsgcazita: 36000
      endmsgcazita: 40000
      startcazita: 48500
      endcazita: 53000
      startdaniela: 54500
      enddaniela: 61000
      startfoodrev: 65000
      endfoodrev: 69000
      startseplantar: 73000
      endseplantar: 77000
      startdesperdicio: 79000
      enddesperdicio: 84000
      endreginaup:91000
      endreginadown: 93900
      starttangerina: 94000
      endtangerina: 100000
      startpomba: 106000
    keyframe: (el, name, dir)->
      fnName = name.split("_")[1]
      fn = API.events[fnName]

      if fn?
        fn(el, dir)
      else
        console.log "definir função para evento #{fnName}"

  })
  


  $(".hotspot-area").on "click", ()->
    API.openHotSpot($(this).data("hotspot"))

  $(".hotspot-wrapper .close").on "click", ()->
    $("body").css("overflow", "")
    $this = $(this)

    API.pauseMedia($(".hotspot-wrapper:visible video")[0])
    API.hotspotOn = false;
    $(".hotspot-wrapper:visible").fadeOut 400, ()->
      API.resumePlaying()
    

$(window).on "unload", ()->
  window.scrollTo(0,0)