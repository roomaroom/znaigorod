handle_adding_poster = ->
  $('.add_poster').click ->
    params = $(this).attr('params')
    target = '.' + $(this).attr('id')

    $(this).slideUp()

    $(target).html($('<iframe/>',
      src: '/el_finder?' + params
      width: '700'
      height: '400'
      scrolling: 'no'
      id: 'el_finder_iframe'
    ).load ->
      $('.content_wrapper').animate
        scrollTop: $(document).height() + $(target).height()
        'slow'
    ).slideDown()

    false

handle_date_picker = ->

$ ->
  handle_adding_poster()
  init_datetime_picker()
  init_jwysiwyg() if $('textarea').length
