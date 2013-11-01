@init_discount_into_filter = () ->
  toggler = $('.filters_wrapper .more_wrapper_toggler .info_button')

  toggler.click ->
    $('.discount_more', $(this).closest('.filters_wrapper')).slideToggle 400, ->
      if $('.discount_more', $(this).closest('.filters_wrapper')).is(':visible')
        toggler.removeClass('open').addClass('close')
      else
        toggler.removeClass('close').addClass('open')
      true
    false

  true
