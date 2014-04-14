@initUlToggle = ->
  $('.js-ul-toggler').click ->

    link = $(this)
    target = $(this).closest('.with-toggleable').find('.js-ul-toggleable')

    target.toggle()
    target.addClass('need_close_by_click')

    target.css
      top: link.position().top + link.outerHeight(true, true) / 2 - target.outerHeight(true, true) / 2
      left: link.position().left + link.outerWidth(true, true) + 10

    false
