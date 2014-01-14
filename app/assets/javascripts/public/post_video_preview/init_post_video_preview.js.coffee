handlePictureClick = ->
  $('.js-video-preview', '.post_item').click ->
    target = $(this)
    content = target.next('.js-video-container')

    dialog = init_modal_dialog
      class:  'video-preview'
      height: 'auto'
      title:  'Видео'
      width:  704

    dialog.html(content.clone())

    false

@initPostVideoPreview = ->
  handlePictureClick()
