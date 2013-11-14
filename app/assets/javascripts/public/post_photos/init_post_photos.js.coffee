@init_post_photos = () ->
  $('.post a[rel="colorbox"]').colorbox
    close: 'закрыть'
    current: '{current} / {total}'
    maxHeight: '90%'
    maxWidth: '90%'
    next: 'следующая'
    photo: true
    previous: 'предыдущая'
    returnFocus: false

  true
