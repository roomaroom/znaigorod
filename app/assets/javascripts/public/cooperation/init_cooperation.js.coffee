@init_cooperation = ->

  poster = $('.cooperation a img')

  poster.each (index, item) ->
    return true if $(this).closest('.statistics').length
    return true if $(this).parent().parent().parent().hasClass('banner12')

    $(this).closest('a').colorbox
      close: 'закрыть'
      current: '{current} / {total}'
      maxHeight: '90%'
      maxWidth: '90%'
      next: 'следующая'
      opacity: '0.6'
      photo: true
      previous: 'предыдущая'
      returnFocus: false

    true

  true
