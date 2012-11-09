@init_webcam_tpu_main = () ->
  link = $("#webcam_tpu_main")
  link.click (event) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    if navigator.appName == "Microsoft Internet Explorer" && navigator.platform != "MacPPC" && navigator.platform != "Mac68k"
      webcam_dialog.html(
        "<center>" +
        "<object width='704' height='576' codebase='http://webcam.tpu.ru/activex/AxisCamControl.cab#Version=1,0,2,15'>" +
        "<param name='DisplaySoundPanel' value=0>" +
        "<param name='url' value='http://webcam.tpu.ru/axis-cgi/mjpg/video.cgi?camera=&resolution=704x576'>" +
        "</object>" +
        "</center>"
      )
    else
      webcam_dialog.html(
        "<center>" +
        "<img src='http://webcam.tpu.ru/axis-cgi/mjpg/video.cgi?camera=&resolution=704x576&#{new Date().getTime()}' " +
        "alt='Press Reload if no image is displayed'>" +
        "</center>"
      )
    webcam_dialog.dialog
      modal: true
      width: 740
      height: 620
      resizable: false
    false

  true

init_webcam_dialog = () ->
  unless $("#webcam_dialog").length
    $("<div id='webcam_dialog' />").appendTo("body")
  $("#webcam_dialog")
