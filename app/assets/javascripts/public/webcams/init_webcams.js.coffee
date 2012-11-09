@init_webcam_tpu_main = () ->
  link = $("#webcam_tpu_main a")
  link.click (event) ->
    render_axis_dialog("http://webcam.tpu.ru/activex/AxisCamControl.cab", "http://webcam.tpu.ru/axis-cgi/mjpg/video.cgi")
    false

  true

@init_webcam_novosobornaya = () ->
  link = $("#webcam_novosobornaya a")
  link.click (event) ->
    render_axis_dialog("http://ctt.tusur.ru/files/webcam/AxisCamControl.cab", "http://campus.tusur.ru/axis-cgi/mjpg/video.cgi")
    false
  true

$.fn.open_dialog = () ->
  $(this).dialog
    modal: true
    width: 740
    height: 620
    resizable: false
  true

render_axis_dialog = (cab_path, cgi_path) ->
  webcam_dialog = init_webcam_dialog()
  webcam_dialog.html("").hide()
  if navigator.appName == "Microsoft Internet Explorer" && navigator.platform != "MacPPC" && navigator.platform != "Mac68k"
    webcam_dialog.html(render_axis_object(cab_path, cgi_path))
  else
    webcam_dialog.html(render_axis_image(cgi_path))
  webcam_dialog.open_dialog()
  true

init_webcam_dialog = () ->
  unless $("#webcam_dialog").length
    $("<div id='webcam_dialog' />").appendTo("body")
  $("#webcam_dialog")

render_axis_object = (cab_path, cgi_path) ->
  width = 704
  height = 576
  "<center>" +
  "<object width='#{width}' height='#{height}' codebase='#{cab_path}#Version=1,0,2,15'>" +
  "<param name='DisplaySoundPanel' value=0>" +
  "<param name='url' value='#{cgi_path}?camera=&resolution=#{width}x#{height}'>" +
  "</object>" +
  "</center>"

render_axis_image = (cgi_path) ->
  width = 704
  height = 576
  "<center>" +
  "<img src='#{cgi_path}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}' " +
  " width='#{width}' height='#{height}' " +
  "alt='Press Reload if no image is displayed'>" +
  "</center>"
