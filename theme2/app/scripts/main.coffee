window.API = {}
API.videos = {}
API.hotspotOn = false
API.continuePlaying = []
API.pauseMedia = (media)->
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

      if video.length > 0
        video[0].play();


$ ()->
  # Adiciona um handler para ajustar o tamanho da página ao  
  # redimensionar a janela do browser
  $(window).unbind('resize', onResize).bind 'resize', onResize

  API.setSize()


API.events =
  startaao: (el, dir)->
    API.playMedia(el)

  endaao: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startcomerciantes: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endcomerciantes: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startrenata: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endrenata: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startluciana: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endluciana: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startovos: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endovos: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startprodutos: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endprodutos: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startadenilson: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endadenilson: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startantonio: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endantonio: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  starthilda: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endhilda: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startmauro: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endmauro: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startsorvete: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endsorvete: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startthais: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endthais: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startsusana: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endsusana: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startfeira: (el, dir)->
    API.playPauseMedia(el, dir is 'down')

  endfeira: (el, dir)->
    API.playPauseMedia(el, dir is 'up')

  startbiel: (el, dir)->
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
      startaao: 0
      endaao: 3000
      startcomerciantes: 10500
      endcomerciantes: 15000
      startrenata: 18000
      endrenata: 22000
      startluciana: 26000
      endluciana: 30000
      startovos: 31200
      endovos: 35000
      startprodutos: 40200
      endprodutos: 45000
      startadenilson: 46200
      endadenilson: 51000
      startantonio: 51000
      endantonio: 56000
      starthilda: 59200
      endhilda: 65000
      startmauro: 66200
      endmauro: 71500
      startsorvete: 71600
      endsorvete: 78500
      startthais: 87200
      endthais: 93000
      startsusana: 95500
      endsusana: 103000
      startfeira: 111000
      endfeira: 116500
      startbiel: 116600
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