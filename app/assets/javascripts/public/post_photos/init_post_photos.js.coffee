@init_post_photos = () ->

  $('.post_show a.colorbox').attr('rel', 'gallery')

  $('.post_show a[rel="colorbox"], .post_show a.colorbox').colorbox
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
