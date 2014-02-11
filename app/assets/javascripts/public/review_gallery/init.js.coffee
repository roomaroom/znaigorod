@init_review_gallery = () ->
  $('.js-gallery a[rel="colorbox"], .js-gallery a.colorbox').colorbox
    close: 'закрыть'
    current: '{current} / {total}'
    maxHeight: '90%'
    maxWidth: '90%'
    next: 'следующая'
    photo: true
    previous: 'предыдущая'
    returnFocus: false
    title: ->
      $(this).attr('title') || $('img', $(this)).attr('alt')

  true
