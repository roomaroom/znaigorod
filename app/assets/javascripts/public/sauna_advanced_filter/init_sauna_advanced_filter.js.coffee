@init_sauna_advanced_filter = () ->
  toggler = $('.filters_wrapper .js-extended-search')

  toggler.click ->
    $('.advanced', $(this).closest('.filters_wrapper')).slideToggle 400, ->
      if $('.advanced', $(this).closest('.filters_wrapper')).is(':visible')
        toggler.html('Расширенный поиск &uarr;')
      else
        toggler.html('Расширенный поиск &darr;')
      true
    false

  true
