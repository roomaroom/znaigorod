@initEditAttachmentDescription = ->
  $('.js-gallery').on 'ajax:success', (event, data) ->
    target = $(event.target)

    if target.hasClass('js-edit-attachment-description')
      dialog = init_modal_dialog
        class:  'description'
        height: 'auto'
        title:  target.data('title')
        width: 640

      form = $(data)
      form.on 'ajax:success', (event, data) ->
        target.text(data)
        dialog.dialog('close')

      dialog.html(form)
