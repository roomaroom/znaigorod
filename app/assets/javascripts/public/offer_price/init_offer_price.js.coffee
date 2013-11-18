init_dialog = (options) ->
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

set_phone_mask = ->
  $('#offer_phone').inputmask 'mask', mask: '+7-(999)-999-9999'

handle_dialog = (dialog, target) ->
  set_phone_mask()

  dialog.on 'ajax:success', (evt, response) ->
   if $(response).is('form')
     dialog.html(response)
     set_phone_mask()
   else
     dialog.dialog('close')
     $(response).prependTo(target).show('slide')

handle_help = ->
  $('.help', '.offers_wrapper').on 'click', ->
    content = $('.description', $(this).closest('.offers_wrapper'))

    dialog = init_dialog
      class:  'description'
      height: 390
      title:  $(this).attr('title')
      width:  640

    dialog.html(content.clone())

@init_offer_price = ->
  handle_help()

  $('.offer_price').on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    list = $('.offers_list', target.closest('.offers_wrapper'))

    dialog = init_dialog
      class:  target.attr('class')
      height: 390
      title:  target.data('title')
      width:  640

    dialog.html(response)
    handle_dialog(dialog, list)
