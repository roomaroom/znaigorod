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

    dialog = init_modal_dialog
      class:  'description'
      height: 'auto'
      title:  $(this).attr('title')
      width: 797

    dialog.html(content.clone())

handle_anchor_offer_price = ->
  $('.offer_price').click() if window.location.hash == '#offer_price'

handle_offer_price_click = ->
  $('.offer_price').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length

      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      init_auth()

      return false

    unless $('.social_signin_links', $(response)).length
      list = $('.offers_list', target.closest('.offers_wrapper'))

      dialog = init_modal_dialog
        class:  target.attr('class')
        height: 565
        title:  target.data('title')
        width:  797

      dialog.html(response)
      handle_dialog(dialog, list)

@init_offer_price = ->
  handle_help()
  handle_anchor_offer_price()
  handle_offer_price_click()

