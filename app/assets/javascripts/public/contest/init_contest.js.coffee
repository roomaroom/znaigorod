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
  true
