@init_contest = () ->
  $('.content_wrapper .contest .works ul li a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
    'title': ->
      $('.title', $(this).closest('li')).text()
  true
