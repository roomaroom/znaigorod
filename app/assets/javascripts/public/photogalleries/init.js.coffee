@init_next_image = ->
  selected = $('a.selected', 'div.photogallery')
  next = selected.parent().next().find('a')[0]
  prev = selected.parent().prev().find('a')[0]

  if selected.length
    $('.js-next-image').click ->
      next.click() if selected.parent().next().find('a').length

    $('.js-prev-image').click ->
      prev.click() if selected.parent().prev().find('a').length
