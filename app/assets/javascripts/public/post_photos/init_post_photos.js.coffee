@init_post_photos = () ->
  $('.post a[rel="colorbox"]').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
  true
