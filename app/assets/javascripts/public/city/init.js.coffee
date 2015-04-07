@init_change_city = () ->
  $('.js-select-city').change ->
    if $('#city_js-city').val() == 'Севастополь'
      window.location = 'http://sevastopol.znaigorod.ru'
    else
      window.location = 'http://znaigorod.ru'
