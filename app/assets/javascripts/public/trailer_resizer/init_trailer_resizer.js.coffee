$ ->
  $allVideos = $("iframe[src^='http://player.vimeo.com'], iframe[src^='http://www.youtube.com'], object, embed")
  $fluidEl = $(".trailer")
  $allVideos.each ->
    $this = $(this)
    $this.attr("data-aspectRatio", @height / @width).removeAttr("height").removeAttr("width")

  $(window).resize(->
     newWidth = $fluidEl.width()
     $allVideos.each ->
       $el = $(this)
       $el.width(newWidth).height newWidth * $el.attr("data-aspectRatio")
   ).resize()
