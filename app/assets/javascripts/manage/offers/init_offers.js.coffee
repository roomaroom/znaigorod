@init_offers = () ->
  cancel_handler = () ->
    $('.cancel').on 'click', ->
      remove_form()
      show_block()

      false
    false

  remove_form = () ->
    $('form', '.offers').remove()

  show_block = () ->
    $('.amount:hidden').show()


  $('.offers').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('edit')
      target.closest('.amount').hide()
      target.closest('li').append(response)

    if target.hasClass('simple_form edit_offer')
      target.closest('li').replaceWith(response)

    cancel_handler()

