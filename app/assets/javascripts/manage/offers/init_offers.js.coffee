@init_offers = () ->
  cancel_handler = () ->
    $('.cancel').on 'click', ->
      $(this).closest('li').find('.edit').removeClass('disabled')

      remove_form()
      show_block()

      false
    false

  remove_form = () ->
    $('form', '.offers').remove()

  show_block = () ->
    $('.amount:hidden').show()

  animate_handler = () ->
    if window.location.hash
      anchor = window.location.hash
      $(anchor).animate
        backgroundColor: "#ffd041"
      , 500

  $('.offers').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('edit')
      target.closest('.amount').hide()
      target.closest('li').append(response)
      target.addClass('disabled')

    if target.hasClass('simple_form edit_offer')
      if $(response).is('form')
        target.closest('form').replaceWith(response)
      else
        target.closest('li').replaceWith(response)

    cancel_handler()

  $('.edit').on 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')
    true

  true

  animate_handler()

