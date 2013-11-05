@init_discount_members = () ->
  $('.left', '.discount_show').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      return false

    if target.hasClass('participate')
      $('.social_actions').replaceWith(response)
      init_countdown()
      init_payment()
