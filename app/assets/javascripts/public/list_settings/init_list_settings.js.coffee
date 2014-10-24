@init_list_settings = () ->

  unless $.cookie
    console.error '$.cookie() is not a function. please include it' if console && console.error
    return false

  $.cookie.defaults =
    path: '/'
    expires: 365

  presentation_block = $('.content_wrapper .presentation_filters')

  cookie_name = ''
  cookie_value = {}

  if presentation_block.hasClass('afisha')
    cookie_name = '_znaigorod_afisha_list_settings'

  if presentation_block.hasClass('accounts')
    cookie_name = '_znaigorod_accounts_list_settings'

  if presentation_block.hasClass('post')
    cookie_name = '_znaigorod_post_list_settings'

  cookie_value.present_by = $('.present_by li.selected a', presentation_block).attr('class')
  cookie_value.order_by = $('.order_by li.selected a', presentation_block).attr('class')
  $.cookie(cookie_name, $.param(cookie_value))

  $('a', presentation_block).click ->
    return false if $(this).closest('li').hasClass('selected')

    true

  true
