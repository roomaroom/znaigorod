init_dialog = (options) ->
  dialog = $("<div class='video_help_dialog' />").dialog
    draggable: false
    height:    options.height
    modal:     true
    position:  ['center', 'top']
    resizable: false
    title:     options.title
    width:     options.width

    close: (event, ui) ->
      $('body').css('overflow', 'auto')
      $(this).dialog('destroy').remove()

  dialog

@initMyReviewVideoHelp = ->
  content = $('.js-video-help-content')

  $('.js-video-help').click ->
    dialog = init_dialog
      height: 'auto'
      title:  'Помощь добавления видео с YouTube или Vimeo'
      width: 885

    dialog.html(content)
  false
