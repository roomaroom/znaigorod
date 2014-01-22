@init_webcam_jw = () ->

  conteainer = $(".webcam_show .webcam_jw")
  width      = conteainer.attr("data-width")
  height     = conteainer.attr("data-height")
  file       = conteainer.attr("data-file")

  html = "" +
    "<div id='jwplayer_container'>" +
    "<video src='#{file} width=#{width} height=#{height} /></video>" +
    "</div>"
  console.log file
  conteainer.html(html)
  jwplayer.key = 'SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg='

  jwplayer('jwplayer_container').setup
    autostart: true
    file: file
    flashplayer: '/assets/jwplayer.swf'
    html5player: '/assets/jwplayer/jwplayer.html5.js'
    width: width
    height: height
    modes: [
      {
        type: 'html5'
      }
      {
        type: 'flash'
        src: '/assets/jwplayer.swf'
      }
    ]

  true
