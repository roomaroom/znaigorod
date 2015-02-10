@init_sauna_advanced_filter = () ->
  toggler = $('.js-extended-search')

  toggler.click ->
    $('.advanced', $(this).closest('.js-filters-wrapper')).slideToggle 400, ->
      if $('.advanced', $(this).closest('.js-filters-wrapper')).is(':visible')
        toggler.html('Расширенный поиск &uarr;')
      else
        toggler.html('Расширенный поиск &darr;')
      true
    false

  true
