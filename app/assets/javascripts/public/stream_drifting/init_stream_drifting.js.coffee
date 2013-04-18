@init_stream_drifting = () ->
  jwplayer.key = "SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg="
  block = $(".river").closest(".info")
  $(".image", block).css
    "float": "right"
  $(".text h3", block).css
    "margin": "10px 0"
  $(".river").each (index, item) ->
    id = $(item).attr("id")

    jwplayer(id).setup
      playlist: [
        image: "http://62.76.185.224/img/#{id}.jpg"
        file: "http://62.76.185.224/hls/#{id}.m3u8"
      ]
      logo:
        file: "http://stream.cam.tom.ru/img/logo.png"
        link: "http://cam.tom.ru/"
      flashplayer: "/assets/jwplayer.swf"
      width: "640"
      height: "360"
      fallback: false

    true

  true
