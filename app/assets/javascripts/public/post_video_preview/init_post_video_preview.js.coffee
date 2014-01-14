videoContainer = (uid, width) ->
  src = "//www.youtube.com/embed/#{uid}?autoplay=1&wmode=opaque"
  iframe = "<iframe width='#{width}' height='315' src='#{src}' frameborder='0' allowfullscreen></iframe>"

  $('<div class="video-container"></div>').html(iframe)

handlePictureClick = ->
  $('.js-video-preview', '.post_item').click ->
    target = $(this)

    uid = target.data('video').uid
    width = target.data('video').width

    dialog = init_modal_dialog
      class:  'video'
      height: 'auto'
      title:  'Видео'
      width:  704

    dialog.html videoContainer(uid, width)

    false

@initPostVideoPreview = ->
  handlePictureClick()
