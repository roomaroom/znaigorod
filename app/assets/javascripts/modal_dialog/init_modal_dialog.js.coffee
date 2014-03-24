@init_modal_dialog = (options) ->
  dialog = $("<div class='#{options.class}_dialog' />").dialog
    draggable: false
    height:    options.height
    modal:     true
    position:  ['center', 50]
    resizable: false
    title:     options.title
    width:     options.width

    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')

    close: (event, ui) ->
      $('body').css('overflow', 'auto')
      $(this).dialog('destroy').remove()

  dialog

