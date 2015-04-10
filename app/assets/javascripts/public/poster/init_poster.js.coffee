@disableAvatarWrapperLinkClick = ->
  $('.js-non-clickable-avatar a').click -> false

@init_poster = () ->
  poster = $('.content .left .image a img')
  return true if poster.hasClass('stub') || poster.parent().parent().parent().hasClass('stub')

  poster.each (index, item) ->
    $(item).closest('a').colorbox
      close: 'закрыть'
      current: '{current} / {total}'
      maxHeight: '90%'
      maxWidth: '90%'
      next: 'следующая'
      opacity: '0.6'
      photo: true
      previous: 'предыдущая'
      returnFocus: false
      title: ->
        $(this).attr('title') || $('img', this).attr('alt') || '&nbsp;'

    true

  true
