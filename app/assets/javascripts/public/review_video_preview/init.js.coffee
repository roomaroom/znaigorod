videoContainer = (src, width) ->
  iframe = "<iframe width='#{width}' height='315' src='#{src}' frameborder='0' allowfullscreen></iframe>"

  $('<div class="video-container"></div>').html(iframe)

handlePictureClick = ->
  $('.js-video-preview', '.item').click ->
    target = $(this)

    src = target.data('video').src
    width = target.data('video').width

    dialog = init_modal_dialog
      class:  'video'
      height: 'auto'
      title:  'Видео'
      width:  704

    dialog.html videoContainer(src, width)

    false

@initReviewVideoPreview = ->
  handlePictureClick()
