console.log "'Allo from CoffeeScript!"

API = {}
 
$(window).load ->
  API.skrollr = skrollr.init({
    render: (data)->
      console.log data
      if data.curTop >= 0 and data.curTop < 1500
        $(".scene-1 video")[0].play()
      else
        $(".scene-1 video")[0].pause()

      if data.curTop > 1000 and data.curTop < 8500
        $(".scene-2 audio")[0].play()
        $(".scene-2 video")[0].play()
      else
        $(".scene-2 video")[0].pause()
        $(".scene-2 audio")[0].pause()

      if data.curTop > 3500 and data.curTop < 6500
        $(".scene-3 video")[0].play()
      else
        $(".scene-3 video")[0].pause()
  })