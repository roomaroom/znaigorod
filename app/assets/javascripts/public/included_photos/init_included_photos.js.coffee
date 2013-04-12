@init_included_photos = () ->
  if $('.photogallery').closest('.organization_info').length
    scroll = 6
    visible = 7
  if $('.photogallery').closest('.post').length
    scroll = 5
    visible = 6
  if $('.photogallery').closest('.affiche').length
    $('.photogallery li a').attr('rel', 'affiche_gallery')
    scroll = 5
    visible = 6
  $('.photogallery ul').jcarousel
    scroll: scroll
    visible: visible
  $('.photogallery a').colorbox
    'close': 'закрыть'
    'current': '{current} / {total}'
    'maxHeight': '98%'
    'maxWidth': '90%'
    'next': 'следующая'
    'opacity': '0.6'
    'photo': 'true'
    'previous': 'предыдущая'
  true
