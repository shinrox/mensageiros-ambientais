console.log "'Allo from CoffeeScript!"

API = {}
API.videos = {}
API.hotspotOn = false
API.playPauseVideo = (id, play)->
  video = API.videos["v" + id]
  return if !video
  if play and video.paused
    video.play()
  else
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
 
API.openHotSpot = (hotspot)->
  $(".hotspot-wrapper[data-hotspot='#{hotspot}']").fadeIn 500, (e)->
    $this = $(this)
    API.hotspotOn = true;
    API.pauseAll().then ()->
      $this.find("video")[0].play();

$(window).load ->
  API.videos =
    v1: $(".scene-1 video")[0]
    v2: $(".scene-2 video")[0]
    v3: $(".scene-3 video")[0]

  API.skrollr = skrollr.init({
    render: (data)->

      return if API.hotspotOn
      if data.curTop >= 0 and data.curTop < 1500
        API.playPauseVideo(1, true)
      else
        API.playPauseVideo(1, false)

      if data.curTop > 1300 and data.curTop < 22000
        $(".scene-2 audio")[0].play()
        API.playPauseVideo(2, true)
      else
        API.playPauseVideo(2, false)
        
        $(".scene-2 audio")[0].pause()

      if data.curTop > 4000 and data.curTop < 9500
        API.playPauseVideo(3, true)
        
      else
        API.playPauseVideo(3, false)
        
  })


  $(".hotspot-area").on "click", ()->
    API.openHotSpot($(this).data("hotspot"))

  $(".hotspot-wrapper .close").on "click", ()->
    $this = $(this)
    API.pauseAll().then ()->
      API.hotspotOn = false;
      $(".hotspot-wrapper").fadeOut(400)