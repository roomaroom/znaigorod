@initEditAttachmentDescription = ->
  $('.js-edit-attachment-description').on 'ajax:success', (event, data) ->
    link = $(this)

    dialog = init_modal_dialog
      class:  'description'
      height: 'auto'
      title:  $(this).data('title')
      width: 640

    form = $(data)
    form.on 'ajax:success', (event, data) ->
      link.text(data)
      dialog.dialog('close')

    dialog.html(form)
