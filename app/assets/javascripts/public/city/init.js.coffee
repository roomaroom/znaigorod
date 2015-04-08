@init_change_city = () ->
  $('.js-city-selector').click ->
    $('.js-selector').toggle()
    if $('.js-selector').is(':visible')
      $('.js-city-arrow').html('&uarr;')
    else
      $('.js-city-arrow').html('&darr;')

    false

  $('.js-selector a').click ->
    if $(this).attr('data-city') == 'sevastopol'
      window.location = 'http://sevastopol.znaigorod.ru'
    else
      window.location = 'http://znaigorod.ru'

    false
