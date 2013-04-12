@init_poster = () ->
  $('.content .info .image a, .organization_info .info .image a').colorbox
    'close': 'закрыть'
    'current': '{current} / {total}'
    'maxHeight': '98%'
    'maxWidth': '90%'
    'next': 'следующая'
    'opacity': '0.6'
    'photo': 'true'
    'previous': 'предыдущая'
