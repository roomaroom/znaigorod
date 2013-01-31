@init_contest = () ->
  toggler =  $('.content_wrapper .contest .toggler a')
  toggable =  $('.content_wrapper .contest .toggable')
  if toggler.length && toggable.length
    toggler.toggleClass('closed')
    toggler_html = toggler.html()
    toggler.html(toggler_html.add(' &darr;'))
    toggler.click (event) ->
      toggler.toggleClass('closed')
      if toggler.hasClass('closed')
        toggable.slideUp 'fast', ->
          toggler.html(toggler_html.add(' &darr;'))
          true
      else
        toggable.slideDown 'fast', ->
          toggler.html(toggler_html.add(' &uarr;'))
      false
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
